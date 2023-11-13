//
//  UDManager.swift
//  Extensions
//
//  Created by 강동영 on 2023/11/13.
//

import Foundation


@propertyWrapper
struct UDOptionalWrapper<T> {
    private let ud = UserDefaults.standard
    var key: String
    var wrappedValue: T? {
        get {
            return ud.value(forKey: key) as? T
        }
        set {
            ud.setValue(newValue, forKey: key)
            ud.synchronize()
        }
    }
}

@propertyWrapper
struct UDWrapper<T> {
    private let ud = UserDefaults.standard
    var key: String
    var defaultValue: T
    var wrappedValue: T {
        get {
            return ud.value(forKey: key) as? T ?? defaultValue
        }
        set {
            ud.setValue(newValue, forKey: key)
            ud.synchronize()
        }
    }
}

enum TypeCodeEnum: String {
    case wait = "W0001"
    case success = "S0000"
    case failed = "F001"
}

struct UDManager {
    @UDWrapper(key: "uuid", defaultValue: "")
    static var uuid: String
    
    @UDOptionalWrapper(key: UDStringKey.name.rawValue)
    static var name: String?
    
    @UDWrapper(key: UDStringKey.isFirst.rawValue, defaultValue: false)
    static var isFirst: Bool
    
    @UDWrapper(key: UDStringKey.tellNumber.rawValue, defaultValue: 0)
    static var tellNumber: Int
    
    // Custom Type
    static var cateExpCode: TypeCodeEnum {
        get {
            guard
                let strValue = UserDefaults.standard.value(forKey: UDStringKey.typeCodeEnum.rawValue) as? String,
                let enumValue = TypeCodeEnum(rawValue: strValue)
            else { return .wait }
            
            return enumValue
        }
        set {
            let ud = UserDefaults.standard
            ud.setValue(newValue.rawValue, forKey: UDStringKey.typeCodeEnum.rawValue)
        }
    }
    
    // tuple for userDefaults
    static var lastFilterCateInfo: (name: String, tellNum: Int)? {
        get {
            let ud = UserDefaults.standard
            let baseKey = UDStringKey.userInfo.rawValue
            let nameKey = baseKey + "_Key"
            let numKey = baseKey + "_Num"
            
            guard
                let nm = ud.value(forKey: nameKey) as? String,
                let num = ud.value(forKey: numKey) as? Int
            else { return nil }
            
            return (nm,num)
        }
        set {
            let ud = UserDefaults.standard
            let baseKey = UDStringKey.userInfo.rawValue
            let nameKey = baseKey + "_Key"
            let numKey = baseKey + "_Num"
            
            ud.setValue(newValue?.name, forKey: nameKey)
            ud.setValue(newValue?.tellNum, forKey: numKey)
        }
    }    
}
