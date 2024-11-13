//
//  LoadableButton.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit

enum ButtonState {
    case loading
    case success
    case failed
}

final class LoadableButton: UIView {
    lazy var button = UIButton().parent(view: self)
    fileprivate lazy var loadingView = LoadingView().parent(view: button)

    fileprivate var title = ""

    var actionBtnTapped: (() -> Void)?
    var stateAction: (() -> Void)?

    init() {
        super.init(frame: UIScreen.main.fixedCoordinateSpace.bounds)

        setupConstraints()
        setupViews()
        setupInteractions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func showLoadingView(_ show: Bool) {
        if show {
            loadingView.show()
            button.setTitle("", for: .normal)
        } else {
            loadingView.hide()
            button.setTitle(title, for: .normal)
        }
    }

    fileprivate func setupInteractions() {
        button.addTarget(self, action: #selector(buttonTappedHandler), for: .touchUpInside)
    }

    @objc fileprivate func buttonTappedHandler() {
        actionBtnTapped?()
    }

    // MARK: SET UP VIEWS
    fileprivate func setupViews() {
        button.style {
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        }
    }

    // MARK: SET UP CONSTRAINTS
    fileprivate func setupConstraints() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// Usable Function
extension LoadableButton {
    public func setState(_ buttonState: ButtonState) {
        switch buttonState {
        case .loading:
            showLoadingView(true)
        case .success:
            showLoadingView(false)
            stateAction?()
        case .failed:
            showLoadingView(false)
            stateAction?()
        }
    }

    public func setTitle(title: String, fontSize: CGFloat = 15) {
        self.title = title
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .semibold)
    }

    public func setButtonSizeToFit(edges: UIEdgeInsets = UIEdgeInsets(top: 12, left: 58, bottom: 12, right: 48)) {
        button.sizeToFit()
        button.contentEdgeInsets = edges
    }

    public func setTitleColor(color: UIColor) {
        button.setTitleColor(color, for: .normal)
    }

    public func setButtonColor(color: UIColor) {
        button.backgroundColor = color
    }
}
