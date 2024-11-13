//
//  TextFieldView.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import UIKit

class TextFieldView: UIView {
    lazy var label = UILabel().parent(view: self)
    lazy var textField = UITextField().parent(view: self)
    
    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    public func initialize(labelText: String, placeholder: String) {
        label.text = labelText
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.7)]
        )
        
        setupConstraint()
        setupView()
    }

    func replaceRightView(view: UIView?) {
        if let view = view {
            textField.rightView = view
        }
        textField.rightView = nil
    }
    
    // MARK: SET UP VIEWS
    func setupView() {
        label.style {
            $0.textColor = UIColor(named: "TextColor")
            $0.font = .systemFont(ofSize: 13)
        }
        
        textField.style {
            $0.setLayer(cornerRadius: 12, borderWidth: 1, borderColor: .gray.withAlphaComponent(0.6))
            $0.textColor = UIColor(named: "TextColor")
            $0.autocorrectionType = .no
            $0.backgroundColor =  UIColor(named: "CardColor")
            $0.font = .systemFont(ofSize: 13)
            $0.leftViewMode = .always
            $0.rightViewMode = .always
            $0.autocapitalizationType = .none
            
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            $0.leftView = paddingView
            $0.rightView = paddingView
        }
    }
    
    // MARK: SET UP CONSTRAINTS
    func setupConstraint() {
        label.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}