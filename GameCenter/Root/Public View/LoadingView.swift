//
//  LoadingView.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit
import Lottie

final class LoadingView: UIView {

    private lazy var animationView = LottieAnimationView(name: "buttonLoading")

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(animationView)

        setupConstraint()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        alpha = 1
        animationView.play()
    }

    func hide() {
        animationView.stop()
        alpha = 0
    }

    func setupView() {
        alpha = 0
        animationView.loopMode = .autoReverse
    }

    func setupConstraint() {
        animationView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(75)
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}