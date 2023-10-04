//
//  Encodable+.swift
//  Extensions
//
//  Created by 강동영 on 2023/10/04.
//

import Foundation

extension Encodable {
    func convertToDic() -> NSDictionary? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let convertedData = try encoder.encode(self)
            let convertedDict = try JSONSerialization.jsonObject(with: convertedData, options: []) as? NSDictionary
            return convertedDict
        } catch {
            return nil
        }
    }
}
