//
//  UIColor+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit

extension UIColor {
    static var backgroundColor = UIColor(named: "BackgroundColor")
    static var baseColor = UIColor(red: 250/255, green: 30/255, blue: 78/255, alpha: 1)
    
    convenience init(hexa: Int, alpha: CGFloat = 1) {
        let mask = 0xFF
        let limit: CGFloat = 255.0
        let red = CGFloat((hexa >> 16) & mask) / limit
        let green = CGFloat((hexa >> 8) & mask) / limit
        let blue = CGFloat(hexa & mask) / limit
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
