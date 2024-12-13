//
//  Array+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 12/09/22.
//

import UIKit

extension Array {
    public func get(_ index: Int) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}

extension Array where Element: UIView {
    public func style(_ callback: ((Element) -> Void)) {
        for item in self {
            callback(item)
        }
    }
}

extension Array where Element: UIBarItem {
    public func style(_ callback: ((Element) -> Void)) {
        for item in self {
            callback(item)
        }
    }
}

extension Array where Element: UIGestureRecognizer {
    public func style(_ callback: ((Element) -> Void)) {
        for item in self {
            callback(item)
        }
    }
}
