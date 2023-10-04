//
//  UIButton+.swift
//  Extensions
//
//  Created by 강동영 on 2023/10/04.
//

import UIKit.UIButton

@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

extension UIButton {
    /// background 컬러 지정
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}

// MARK: - setLayer with enum-switch expression
extension UIButton {
    enum ButtonLayer {
        case top
        case bottom
        case left
        case right
        
        var layerIdentifier: String {
            switch self {
                
            case .top:
                return "topLayer"
            case .bottom:
                return "bottomLayer"
            case .left:
                return "leftLayer"
            case .right:
                return "rightLayer"
            }
        }
    }
    
    
    /// Layer 별로 사용가능한
    /// - Parameters:
    ///   - color: color value
    ///   - width: only use left, right layer
    ///   - height: only use top, bottom layer
    ///   - type: top, bottom, left, right
    func setLayer(color: UIColor, width: CGFloat = 0, height: CGFloat = 0, for type: UIButton.ButtonLayer) {
        let variableLayer = CALayer()
        
        switch type {
            
        case .top:
            variableLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        case .bottom:
            variableLayer.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: height)
        case .left:
            variableLayer.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        case .right:
            variableLayer.frame = CGRect(x: frame.width - 1, y: 0, width: width, height: frame.height)
        }
        variableLayer.backgroundColor = color.cgColor
        variableLayer.accessibilityValue = type.layerIdentifier
        layer.addSublayer(variableLayer)
    }
}

// MARK: - setLayer with dot chaining expression
extension UIButton {
    @discardableResult
    func setTopLayer(color: UIColor, height: CGFloat) -> UIButton {
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: height)
        topLayer.backgroundColor = color.cgColor
        topLayer.accessibilityValue = "topLayer"
        layer.addSublayer(topLayer)
        
        return self
    }
    
    @discardableResult
    func setBottomLayer(color: UIColor, height: CGFloat) -> UIButton {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: height)
        bottomLayer.backgroundColor = color.cgColor
        bottomLayer.accessibilityValue = "bottomLayer"
        layer.addSublayer(bottomLayer)
        
        return self
    }
    
    @discardableResult
    func setLeftLayer(color: UIColor, width: CGFloat) -> UIButton {
        
        let leftLayer = CALayer()
        leftLayer.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
        leftLayer.backgroundColor = color.cgColor
        leftLayer.accessibilityValue = "leftLayer"
        layer.addSublayer(leftLayer)
        
        return self
    }
    
    @discardableResult
    func setRightLayer(color: UIColor, width: CGFloat) -> UIButton {
        
        let rightLayer = CALayer()
        rightLayer.frame = CGRect(x: frame.width - 1, y: 0, width: width, height: frame.height)
        rightLayer.backgroundColor = color.cgColor
        rightLayer.accessibilityValue = "rightLayer"
        layer.addSublayer(rightLayer)
        
        return self
    }
}
