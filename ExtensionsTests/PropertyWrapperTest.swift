//
//  PropertyWrapperTest.swift
//  ExtensionsTests
//
//  Created by 강동영 on 11/13/23.
//

import XCTest
@testable import Extensions

final class PropertyWrapperTest: XCTestCase {

    private struct DummyJsonDTO: Decodable {
        let name: String
        let weight: Double
        let isHomeProtector: Bool
        let height: Double?
    }
    
    private struct DummyJsonWrapperDTO: Decodable {
        let name: String
        let weight: Double
        let isHomeProtector: Bool
        @JWDoubleZero var height: Double
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUDManager() {
        let isFirst = UDManager.isFirst //defaultValue: false
        print("let isFirst: \(isFirst)")
        
        let greenResult = UDManager.isFirst == isFirst
        assert(greenResult, "toggle success: \(greenResult) isFirst: \(isFirst)")
        UDManager.isFirst.toggle()
        let redResult = UDManager.isFirst != isFirst
        XCTAssert(redResult, "toggle success: \(redResult) isFirst: \(isFirst)")
    }
    
    func testJSONSerialization() -> String {
        let dict: Dictionary<String, Any> = ["name": "Arex", "weight": 86.4, "isHomeProtector": true]
        let jsonString = dict.toJSON()
        XCTAssert(jsonString != nil, "JSON serialization failed")
        return jsonString!
    }

    func testJSONDefaultDecodable() {
        let jsonString = testJSONSerialization()
        let data = jsonString.data(using: .utf8)
        assert(data != nil, "JSON serialization failed")
        let decoder = JSONDecoder()
        
        do {
            let data = try decoder.decode(DummyJsonDTO.self, from: data!)
            print(#function)
            
            XCTAssert(data.height != nil, "height is nil")
        } catch {
            
        }
    }
    
    func testJSONDefaultWrapper() {
        let jsonString = testJSONSerialization()
        let data = jsonString.data(using: .utf8)
        assert(data != nil, "JSON serialization failed")
        let decoder = JSONDecoder()
        
        do {
            let data = try decoder.decode(DummyJsonWrapperDTO.self, from: data!)
            print(#function)
            
            XCTAssert(data.height != nil, "height is nil")
        } catch {
            
        }
        
    }
    
    private func getValueName(type: DummyJsonWrapperDTO) {
        let mirror = Mirror(reflecting: type)
        
        mirror.children.forEach({
            print("label: \($0.label!), value: \($0.value)")
        })
    }
}
