//
//  UIAppearance+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 12/09/22.
//

import UIKit

extension UIAppearance {
    public func style(_ completion: @escaping ((Self) -> Void)) {
        completion(self)
    }
}
