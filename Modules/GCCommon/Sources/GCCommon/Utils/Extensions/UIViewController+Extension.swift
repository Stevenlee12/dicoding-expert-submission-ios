//
//  UIViewController+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit

extension UIViewController {
    public func setBackTitle(_ title: String = "") {
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }

    public func setAsPopupViewController() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
    }

    public func dismissKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    public func presentAlert(title: String, message: String, alertAction items: [UIAlertAction] = [], _ completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for item in items {
            alert.addAction(item)
        }
        if items.count == 0 {
            alert.addAction(
                UIAlertAction(title: "Close", style: .cancel, handler: nil)
            )
        }
        present(alert, animated: true, completion: completion)
    }

    public func presentActionSheet(title: String? = nil, message: String? = nil, alertAction items: [UIAlertAction] = [], _ completion: (() -> Void)? = nil) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            presentAlert(title: title!, message: message!, alertAction: items, completion)
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for item in items {
            alert.addAction(item)
        }
        if items.count == 0 {
            alert.addAction(
                UIAlertAction(title: "Close", style: .cancel, handler: nil)
            )
        }
        present(alert, animated: true, completion: completion)
    }

    public func showAlert(_ title: String, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)

        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor(named: "AlertTextColor") ?? UIColor.white
        ]
        
        let titleString = NSAttributedString(string: title, attributes: titleAttributes)

        let messageAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor(named: "AlertSubTextColor") ?? UIColor.white
        ]
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttributes)

        alert.setValue(titleString, forKey: "attributedTitle")
        alert.setValue(messageString, forKey: "attributedMessage")

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
}
