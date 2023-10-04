//
//  NSDictionary+.swift
//  Extensions
//
//  Created by 강동영 on 2023/10/04.
//

import Foundation.NSDictionary

extension NSDictionary {
    func convertToQparam() -> String {
        let param = self.convertToQueryParam()
        let customAllowedSet =  NSCharacterSet(charactersIn:"() ,&=\"#%/<>?@\\^`{|}").inverted
        let escapedString = (param as NSString).addingPercentEncoding(withAllowedCharacters: customAllowedSet)
        return "q=\(escapedString ?? "")"
    }
    
    func convertToQueryParam() -> String {
        var query = ""
        
        var list = self.map{(key: ($0.key as? String) ?? "", value: $0.value)}.filter{$0.key != ""}
        list = list.sorted(by: {$0.key < $1.key})
        
        for row in list {
            if query.count != 0 {
                query += "&"
            }
            query += "\(row.key)=\(row.value)"
        }
        
        return query
    }
}
