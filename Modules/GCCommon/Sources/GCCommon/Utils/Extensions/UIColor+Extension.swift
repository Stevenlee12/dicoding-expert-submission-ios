//
//  UIColor+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit

extension UIColor {
    public static var backgroundColor: UIColor {
        return UIColor(named: "BackgroundColor", in: Bundle.module, compatibleWith: nil) ?? UIColor.clear
    }
    
    public static var baseColor: UIColor {
        return UIColor(red: 250/255, green: 30/255, blue: 78/255, alpha: 1)
    }
    
    public static var textColor: UIColor {
        return UIColor(named: "TextColor", in: Bundle.main, compatibleWith: nil) ?? UIColor.black
    }
    
    public static var cardColor: UIColor {
        return UIColor(named: "CardColor", in: Bundle.main, compatibleWith: nil) ?? UIColor.black
    }
    
    public convenience init(hexa: Int, alpha: CGFloat = 1) {
        let mask = 0xFF
        let limit: CGFloat = 255.0
        let red = CGFloat((hexa >> 16) & mask) / limit
        let green = CGFloat((hexa >> 8) & mask) / limit
        let blue = CGFloat(hexa & mask) / limit
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
