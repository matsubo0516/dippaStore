//
//  UIImage+Extension.swift
//  dippaStore3
//
//  Created by 松本直樹 on 2019/01/14.
//  Copyright © 2019年 松本直樹. All rights reserved.
//

import UIKit

/// 下記を参考にした
/// https://fussan-blog.com/swift-resize-crop-extension/
extension UIImage {

    func resize(width: CGFloat) -> UIImage? {
        let ratio = width / size.width
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, true, 0.0)

        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return resizedImage
    }

}
