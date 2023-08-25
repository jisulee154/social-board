//
//  Extensions.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit

extension UITabBar {
    /// TabBar height 설정
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        
        sizeThatFits.height = 10
        return sizeThatFits
    }
}
