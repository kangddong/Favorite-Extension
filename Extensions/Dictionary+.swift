//
//  Dictionary+.swift
//  Extensions
//
//  Created by 강동영 on 11/13/23.
//

import Foundation

extension Dictionary {
    func toJSON() -> String? {
        guard let jsonData: Data = try? JSONSerialization.data(
            withJSONObject: self,
            options: .prettyPrinted
        ) else {
            return nil
        }
        
        let encodedString = String(data: jsonData, encoding: .utf8)
        let jsonString = encodedString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
        
        return jsonString
    }
}
