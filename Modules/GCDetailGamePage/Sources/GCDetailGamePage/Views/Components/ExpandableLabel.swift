//
//  ExpandableLabel.swift
//  GameCenter
//
//  Created by Steven Lie on 15/09/22.
//

import UIKit
import GCCommon

final class ExpendableLabel: UIView {
    fileprivate lazy var aboutStackView = UIStackView().parent(view: self)
    fileprivate lazy var aboutTextView = UIView().parent(view: aboutStackView)
    fileprivate lazy var aboutText = UILabel().parent(view: aboutTextView)
    fileprivate lazy var seemoreBtnView = UIView().parent(view: aboutStackView)
    fileprivate lazy var seemoreBtn = UIButton().parent(view: seemoreBtnView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
        setupViews()
        setupInteractions()
    }
    
    public func setLabelText(text: String) {
        seemoreBtn.isHidden = text.count < 30
        aboutText.text = text.count != 0 ? text : "This developer hasn't write an about yet..."
    }
    
    fileprivate func setupInteractions() {
        seemoreBtn.addTarget(self, action: #selector(seemoreBtnTapped), for: .touchUpInside)
    }
    
    @objc fileprivate func seemoreBtnTapped() {
        seemoreBtnView.isHidden = true
        aboutText.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        aboutStackView.style {
            $0.axis = .vertical
            $0.spacing = 0
        }
        
        aboutText.style {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .textColor.withAlphaComponent(0.7)
            $0.numberOfLines = 3
            $0.lineBreakMode = .byTruncatingTail
            $0.textAlignment = .left
        }
        
        seemoreBtn.style {
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.setTitle("See More", for: .normal)
            $0.setTitleColor(.systemBlue, for: .normal)
            $0.backgroundColor = .backgroundColor
        }
    }
    
    fileprivate func setupConstraints() {
        aboutStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        aboutText.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        seemoreBtn.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
