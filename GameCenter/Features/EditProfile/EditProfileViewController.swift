//
//  EditProfileViewController.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import UIKit
import Combine

final class EditProfileViewController: UIViewController {
    
    lazy var root = EditProfileView()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        title = "Edit Profile"
        
        dismissKeyboardOnTap()
        
        root.nameTF.textField.delegate = self
        root.emailTF.textField.delegate = self
        
        setupCombine()
    }
    
    fileprivate func setupCombine() {
        let emailPublisher = root.emailTF.textField.textPublisher()
        let namePublisher = root.nameTF.textField.textPublisher()
        
        let invalidFieldsPublishers = Publishers.Merge(namePublisher, emailPublisher).map { [weak self] _ in
            let name = self?.root.nameTF.textField.text ?? ""
            let email = self?.root.emailTF.textField.text ?? ""
            
            return !name.isEmpty && !email.isEmpty
        }.eraseToAnyPublisher()
        
        invalidFieldsPublishers
            .receive(on: RunLoop.main)
            .sink { [weak self] isValid in
                self?.root.saveBtn.isEnabled = isValid
                self?.updateButtonState()
            }
            .store(in: &cancellables)
        
        root.saveBtnTappedHandler = { [weak self] in
            guard let self else { return }
            
            UserDefault.email.save(value: root.emailTF.textField.text)
            UserDefault.name.save(value: root.nameTF.textField.text)
            
            showAlert("Yayy", message: "Edit profile success!") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    fileprivate func updateButtonState() {
        // Check if the button is enabled or disabled
        if root.saveBtn.isEnabled {
            root.saveBtn.backgroundColor = .baseColor // Enabled state color
        } else {
            root.saveBtn.backgroundColor = .lightGray.withAlphaComponent(0.5) // Disabled state color
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            if let responder: UIResponder = view.viewWithTag(textField.tag + 1) {
                guard responder.isKind(of: UITextField.self) else { return true }
                responder.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
