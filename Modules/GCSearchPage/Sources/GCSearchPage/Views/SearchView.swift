//
//  SearchView.swift
//  GCSearchPage
//
//  Created by Steven Lie on 12/12/24.
//

import UIKit
import GCCommon

final class SearchView: UIView {
    lazy var searchBar = UISearchBar().parent(view: self)
    lazy var searchResultView = CustomViewWithCollectionView().parent(view: self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        setupConstraints()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SET UP VIEWS
    private func setupViews() {
        searchBar.style {
            $0.searchBarStyle = .minimal
            $0.sizeToFit()
            $0.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search your game here",
                attributes: [
                    .foregroundColor: UIColor(named: "TextColor")?.withAlphaComponent(0.7) ?? UIColor(),
                    .font: UIFont.systemFont(ofSize: 13)
                ]
            )
            
            if let textField = $0.value(forKey: "searchField") as? UITextField,
                let iconView = textField.leftView as? UIImageView {
                    
                textField.textColor = UIColor(named: "TextColor")
                textField.font = UIFont.systemFont(ofSize: 13)
                textField.backgroundColor = UIColor(named: "CardColor")
                iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = UIColor(named: "TextColor")
                
            }
        }
        
        searchResultView.style {
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
    
    // MARK: - SET UP CONSTRAINTS
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.lessThanOrEqualTo(48)
        }
        
        searchResultView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
