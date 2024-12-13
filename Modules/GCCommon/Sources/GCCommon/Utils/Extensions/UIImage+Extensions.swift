//
//  UIImage+Extensions.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

import UIKit

extension UIImage {
    public var transparent: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }

    public func resize(_ size: CGSize) -> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage ?? self
    }
}
