//
//  Array+.swift
//  Extensions
//
//  Created by 강동영 on 2023/10/04.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
