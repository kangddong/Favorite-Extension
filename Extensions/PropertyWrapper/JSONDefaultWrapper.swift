/*
 사용법 - 개인 블로그 참고
 https://jiseobkim.github.io/swift/2021/07/18/swift-Property-Wrapper-(feat.-Codable-코드-정리).html
 */
import Foundation

typealias JWEmptyString = JSONDecodeWrapper.EmptyString
typealias JWTrue = JSONDecodeWrapper.True
typealias JWFalse = JSONDecodeWrapper.False
typealias JWIntZero = JSONDecodeWrapper.IntZero
typealias JWDoubleZero = JSONDecodeWrapper.DoubleZero
typealias JWFloatZero = JSONDecodeWrapper.FloatZero
typealias JWCGFloatZero = JSONDecodeWrapper.CGFloatZero
typealias JWStringFalse = JSONDecodeWrapper.StringFalse
typealias JWStringTrue = JSONDecodeWrapper.StringTrue
typealias JWEmptyList = JSONDecodeWrapper.EmptyList
typealias JWEmptyDict = JSONDecodeWrapper.EmptyDict
typealias JWTimestampToDate = JSONDecodeWrapper.TimestampToOptionalDate

protocol JSONDecodeWrapperAvailable {
    associatedtype ValueType: Decodable, Hashable
    static var defaultValue: ValueType { get }
}

protocol JSONStringConverterAvailable {
    static var defaultValue: Bool { get }
}

enum JSONDecodeWrapper {
    typealias EmptyString = Wrapper<JSONDecodeWrapper.TypeCase.EmptyString>
    typealias True = Wrapper<JSONDecodeWrapper.TypeCase.True>
    typealias False = Wrapper<JSONDecodeWrapper.TypeCase.False>
    typealias IntZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<Int>>
    typealias DoubleZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<Double>>
    typealias FloatZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<Float>>
    typealias CGFloatZero = Wrapper<JSONDecodeWrapper.TypeCase.Zero<CGFloat>>
    typealias StringFalse = StringConverterWrapper<JSONDecodeWrapper.TypeCase.StringFalse>
    typealias StringTrue = StringConverterWrapper<JSONDecodeWrapper.TypeCase.StringTrue>
    typealias EmptyList<T: Decodable & ExpressibleByArrayLiteral & Hashable> = Wrapper<JSONDecodeWrapper.TypeCase.List<T>>
    typealias EmptyDict<T: Decodable & ExpressibleByDictionaryLiteral & Hashable> = Wrapper<JSONDecodeWrapper.TypeCase.Dict<T>>
    
    // Property Wrapper - Optional Type to Type
    @propertyWrapper
    struct Wrapper<T: JSONDecodeWrapperAvailable> {
        typealias ValueType = T.ValueType

        var wrappedValue: ValueType

        init() {
        wrappedValue = T.defaultValue
        }
    }
    
    // Property Wrapper - Optional String To Bool
    @propertyWrapper
    struct StringConverterWrapper<T: JSONStringConverterAvailable> {
        var wrappedValue: Bool = T.defaultValue
    }
    
    // Property Wrapper - Optional Timestamp to Optinoal Date
    @propertyWrapper
    struct TimestampToOptionalDate {
        var wrappedValue: Date?
    }

    enum TypeCase {
        // Type Enums
        enum True: JSONDecodeWrapperAvailable {
            // 기본값 - true
            static var defaultValue: Bool { true }
        }

        enum False: JSONDecodeWrapperAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }

        enum EmptyString: JSONDecodeWrapperAvailable {
            // 기본값 - ""
            static var defaultValue: String { "" }
        }
        
        enum Zero<T: Decodable & Hashable>: JSONDecodeWrapperAvailable where T: Numeric {
            // 기본값 - 0
            static var defaultValue: T { 0 }
        }
        
        enum StringFalse: JSONStringConverterAvailable {
            // 기본값 - false
            static var defaultValue: Bool { false }
        }
        
        enum StringTrue: JSONStringConverterAvailable {
            // 기본값 - true
            static var defaultValue: Bool { true }
        }
        
        enum List<T: Decodable & ExpressibleByArrayLiteral & Hashable>: JSONDecodeWrapperAvailable {
            // 기본값 - []
            static var defaultValue: T { [] }
        }
        
        enum Dict<T: Decodable & ExpressibleByDictionaryLiteral & Hashable>: JSONDecodeWrapperAvailable {
            // 기본값 - [:]
            static var defaultValue: T { [:] }
        }
    }
}

extension JSONDecodeWrapper.Wrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(ValueType.self)
    }
}

extension JSONDecodeWrapper.StringConverterWrapper: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try container.decode(String.self)) == "Y"
    }
}

extension JSONDecodeWrapper.TimestampToOptionalDate: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        guard let timestamp = try? container.decode(Double.self) else {
            self.wrappedValue = nil
            return
        }
        let date = Date.init(timeIntervalSince1970: timestamp)
        self.wrappedValue = date
    }
}

// MARK: - KeyedDecodingContainer
extension KeyedDecodingContainer {
    func decode<T: JSONDecodeWrapperAvailable>(_ type: JSONDecodeWrapper.Wrapper<T>.Type, forKey key: Key) throws -> JSONDecodeWrapper.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode<T: JSONStringConverterAvailable>(_ type: JSONDecodeWrapper.StringConverterWrapper<T>.Type, forKey key: Key) throws -> JSONDecodeWrapper.StringConverterWrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: JSONDecodeWrapper.TimestampToOptionalDate.Type, forKey key: Key) throws -> JSONDecodeWrapper.TimestampToOptionalDate {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
    
    func decode(_ type: JSONDecodeWrapper.TypeCodeSampleEnumWrapper.Type, forKey key: Key) throws -> JSONDecodeWrapper.TypeCodeSampleEnumWrapper {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}



// MARK: - JSONDecodeWrapper
extension JSONDecodeWrapper {
    
    // MARK: - Enum Wrapper - Sample
    @propertyWrapper
    struct TypeCodeSampleEnumWrapper: Decodable {
        var wrappedValue: TypeCodeSampleEnum?
        init() {
            wrappedValue = nil
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            wrappedValue = TypeCodeSampleEnum(rawValue: value)
        }
    }
}
