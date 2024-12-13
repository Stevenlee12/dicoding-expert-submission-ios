//
//  UITextField+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 30/10/24.
//

import UIKit
import Combine

extension UITextField {
    public func textPublisher() -> AnyPublisher<String, Never> {
        return NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in self.text ?? "" }
            .eraseToAnyPublisher()
    }
}
