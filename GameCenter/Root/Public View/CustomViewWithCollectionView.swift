//
//  CustomViewWithCollectionView.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit

enum ViewState {
    case loading
    case success
    case failed
    case empty
}

final class CustomViewWithCollectionView: UIView {
    fileprivate lazy var containerView = UIView().parent(view: self)
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).parent(view: containerView)
    fileprivate lazy var loadingLbl = UILabel().parent(view: self)
    fileprivate lazy var emptyLbl = UILabel().parent(view: self)
    fileprivate lazy var tryAgainBtn = LoadableButton().parent(view: self)

    var stateAction: (() -> Void)?
    var tryAgainBtnDidTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContraints()
        setupViews()
        setupInteractions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupInteractions() {
        tryAgainBtn.actionBtnTapped = { [weak self] in
            self?.setState(.loading)
            self?.tryAgainBtnDidTapped?()
        }
    }

    fileprivate func setupViews() {
        loadingLbl.style {
            $0.textColor = UIColor(red: 250/255, green: 30/255, blue: 78/255, alpha: 1)
            $0.textAlignment = .center
            $0.isHidden = true
            $0.font = .systemFont(ofSize: 12)
            $0.text = "Getting your data..."
        }

        emptyLbl.style {
            $0.textColor = UIColor(red: 250/255, green: 30/255, blue: 78/255, alpha: 1)
            $0.textAlignment = .center
            $0.isHidden = true
            $0.font = .systemFont(ofSize: 12)
            $0.text = "No Data."
        }

        collectionView.style {
            $0.backgroundColor = .clear
            $0.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }

        tryAgainBtn.style {
            $0.setTitle(title: "Try Again", fontSize: 12)
            $0.setTitleColor(color: .white)
            $0.setButtonColor(color: UIColor(red: 250/255, green: 30/255, blue: 78/255, alpha: 1))
            $0.isHidden = true
            $0.button.setLayer(cornerRadius: 8)
            $0.button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }

    fileprivate func showLoadingView(_ isLoading: Bool) {
        loadingLbl.isHidden = !isLoading
    }

    fileprivate func showEmptyLabel(_ isEmpty: Bool) {
        emptyLbl.isHidden = !isEmpty
    }

    fileprivate func showErrorButton(_ isError: Bool) {
        tryAgainBtn.isHidden = !isError
    }

    fileprivate func setupContraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }

        loadingLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        tryAgainBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        emptyLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: Reusable Function

extension CustomViewWithCollectionView {
    func registerCell(cell: UICollectionViewCell.Type, identifier: String) {
        collectionView.register(cell.self, forCellWithReuseIdentifier: identifier)
    }

    func setCellTag(tag: Int) {
        collectionView.tag = tag
    }

    func setState(_ state: ViewState) {
        switch state {
        case .loading:
            showLoadingView(true)
            showEmptyLabel(false)
            showErrorButton(false)
        case .success:
            showLoadingView(false)
            showEmptyLabel(false)
            showErrorButton(false)
            tryAgainBtn.setState(.success)
        case .failed:
            showLoadingView(false)
            showEmptyLabel(false)
            showErrorButton(true)
            tryAgainBtn.setState(.failed)
            stateAction?()
        case .empty:
            showLoadingView(false)
            showErrorButton(false)
            showEmptyLabel(true)
        }
    }

    func updateCollectionViewHeight(_ height: Float) {
        collectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }

    func setCollectionViewFlowLayout(_ layout: UICollectionViewLayout) {
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
