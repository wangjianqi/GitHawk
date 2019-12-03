//
//  UIImage+Color.swift
//  Freetime
//
//  Created by Viktoras Laukevicius on 06/02/2019.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

import UIKit

extension UIImage {
    //颜色转图片
    class func from(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
