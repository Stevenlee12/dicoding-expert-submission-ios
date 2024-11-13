//
//  UIWindow+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit

extension UIWindow {
    static var main: UIWindow? {
        return (UIApplication.shared.delegate as! AppDelegate).window
    }
}
