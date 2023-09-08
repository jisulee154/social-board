//
//  Extensions.swift
//  social-board
//
//  Created by 이지수 on 2023/08/25.
//

import UIKit
import RealmSwift

extension UITabBar {
    /// TabBar height 설정
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        
        sizeThatFits.height = 10
        return sizeThatFits
    }
}

//func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
//    let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
//    let newHeight = image.size.height * scale
//    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
//    image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
//    let newImage = UIGraphicsGetImageFromCurrentImageContext()
//    UIGraphicsEndImageContext()
//    return newImage
//}
