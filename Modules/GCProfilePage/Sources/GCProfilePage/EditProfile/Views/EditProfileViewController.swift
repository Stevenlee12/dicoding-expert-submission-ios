//
//  File.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import UIKit
import Combine
import GCProfile

public final class EditProfileViewController: UIViewController {
    lazy var root = EditProfileView()
    
    private var viewModel: EditProfileViewModel = EditProfileViewModel(profileUseCase: ProfileInjection().provideActivitiesLog())
    
    private var cancellables: Set<AnyCancellable> = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view = root
        title = "Edit Profile"
        
        dismissKeyboardOnTap()
        
        root.nameTF.textField.delegate = self
        root.emailTF.textField.delegate = self
        
        viewModel.getUserData()
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
            
            viewModel.updateUserData(user: User(
                name: root.nameTF.textField.text ?? "",
                email: root.emailTF.textField.text ?? "")
            )
            
            showAlert("Yayy", message: "Edit profile success!") { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        viewModel.$email
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.root.emailTF.textField.text = data
            }
            .store(in: &cancellables)
        
        viewModel.$name
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.root.nameTF.textField.text = data
            }
            .store(in: &cancellables)
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
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
