//
//  UIColor+.swift
//  Extensions
//
//  Created by 강동영 on 2023/10/04.
//

import UIKit.UIColor

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

// MARK: - Color Asset 전용
extension UIColor {
    enum AssetType: String {
        case asset_31_39_48
    }
    
    enum AssetName: String{
        case transparentBackground
    }
    
    static func color(_ type: AssetType) -> UIColor? {
        let colorName = type.rawValue
        
        guard let firstIndex = colorName.firstIndex(of: "_") else { return nil }
        let startIndex = colorName.index(after: firstIndex)
        let name = colorName[startIndex..<colorName.endIndex]
        
        return UIColor.init(named: String(name))
    }
    
    static func color(name: AssetName) -> UIColor {
        return UIColor.init(named: name.rawValue) ?? .clear
    }
}
