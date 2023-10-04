//
//  UIScrollView.swift
//  Extensions
//
//  Created by 강동영 on 2023/10/04.
//

import UIKit.UIScrollView

extension UIScrollView {
    var isNeedMoreLoad: Bool {
         guard self.frame.height < self.contentSize.height else { return false }
        let endPosition = self.contentOffset.y + self.frame.height
        let targetY = self.contentSize.height * 0.8
        return endPosition > targetY
    }
}
