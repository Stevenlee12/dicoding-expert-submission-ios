//
//  FavoriteView.swift
//  GameCenter
//
//  Created by Steven Lie on 18/08/21.
//

import UIKit
import SnapKit

final class FavoriteView: UIView {
    lazy var favoriteGameView = CustomViewWithCollectionView().parent(view: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        
        setupConstraints()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        favoriteGameView.style {
            $0.backgroundColor = .clear
            $0.registerCell(cell: GameCell.self, identifier: GameCell.cellIdentifier)
            $0.setCellTag(tag: 0)
            $0.collectionView.bounces = false

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
            $0.setCollectionViewFlowLayout(layout)
        }
    }
    
    fileprivate func setupConstraints() {
        favoriteGameView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
