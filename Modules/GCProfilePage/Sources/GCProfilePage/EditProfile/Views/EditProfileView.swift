//
//  File.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import UIKit
import GCCommon

final class EditProfileView: UIView {
    private lazy var contentView = UIView().parent(view: self)
    lazy var nameTF = TextFieldView().parent(view: contentView)
    lazy var emailTF = TextFieldView().parent(view: contentView)
    
    lazy var saveBtn = UIButton().parent(view: contentView)
    
    var saveBtnTappedHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        
        setupConstraints()
        setupViews()
        setupInteractions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupInteractions() {
        saveBtn.addTarget(self, action: #selector(saveBtnTapped), for: .touchUpInside)
    }
    
    @objc fileprivate func saveBtnTapped() {
        saveBtnTappedHandler?()
    }
    
    fileprivate func setupViews() {
        nameTF.style {
            $0.initialize(labelText: "Name", placeholder: "Name")
            $0.textField.tag = 1
            $0.textField.returnKeyType = .next
        }
        
        emailTF.style {
            $0.initialize(labelText: "Email", placeholder: "Email")
            $0.textField.tag = 2
            $0.textField.returnKeyType = .done
            $0.textField.keyboardType = .emailAddress
        }
        
        saveBtn.style {
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 24)
            $0.sizeToFit()
            $0.setTitle("SAVE", for: .normal)
            $0.setLayer(cornerRadius: 8)
            $0.backgroundColor = .baseColor
        }
    }
    
    fileprivate func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
            make.width.equalToSuperview()
        }
        
        nameTF.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        emailTF.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameTF)
            make.top.equalTo(nameTF.snp.bottom).offset(16)
        }
        
        saveBtn.snp.makeConstraints { make in
            make.top.equalTo(emailTF.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
