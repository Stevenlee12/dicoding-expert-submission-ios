//
//  HeaderView.swift
//  GCHomePage
//
//  Created by Steven Lie on 09/12/24.
//

import UIKit
import SnapKit

import GCCommon

final class HeaderView: UIView {
    fileprivate lazy var headerView = UIView().parent(view: self)
    fileprivate lazy var greetingView = UIView().parent(view: headerView)
    fileprivate lazy var userImage = UIImageView().parent(view: headerView)

    fileprivate lazy var greetingLbl = UILabel().parent(view: greetingView)
    fileprivate lazy var userNameLbl = UILabel().parent(view: greetingView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setGreeting(greeting: String, username: String, image: UIImage) {
        greetingLbl.text = greeting
        userNameLbl.text = username
        userImage.image = image
    }

    fileprivate func setupViews() {
        greetingLbl.style {
            $0.font = .systemFont(ofSize: 13)
            $0.textAlignment = .left
            $0.textColor = .textColor.withAlphaComponent(0.7)
        }

        userNameLbl.style {
            $0.font = .systemFont(ofSize: 24, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .textColor
        }

        userImage.style {
            $0.setLayer(cornerRadius: 0)
            $0.clipsToBounds = true
        }
    }

    fileprivate func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        greetingView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        greetingLbl.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        userNameLbl.snp.makeConstraints { make in
            make.top.equalTo(greetingLbl.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }

        userImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
    }
}
