//
//  HomeView.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    fileprivate lazy var scrollView = UIScrollView().parent(view: self)
    fileprivate lazy var contentView = UIView().parent(view: scrollView)
    lazy var headerView = HeaderView().parent(view: contentView)

    fileprivate lazy var gameGenreView = UIView().parent(view: contentView)
    lazy var gameGenreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout.init()).parent(view: gameGenreView)

    fileprivate lazy var recommendedView = UIView().parent(view: contentView)
    fileprivate lazy var recommendedGameLbl = UILabel().parent(view: recommendedView)
    lazy var recommendedGameView = CustomViewWithCollectionView().parent(view: recommendedView)

    fileprivate lazy var popularGamesLbl = UILabel().parent(view: contentView)
    lazy var popularGamesView = CustomViewWithCollectionView().parent(view: contentView)

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
        setupBaseViews()
        setupHeaderViews()
        setupGameGenreCollectionView()
        setupRecommendedView()
        setupPopularGamesView()
    }

    fileprivate func setupBaseViews() {
        scrollView.style {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
    }

    fileprivate func setupHeaderViews() {
        headerView.setGreeting(
            greeting: "Welcome back,",
            username: UserDefault.name.load() as? String ?? "",
            image: UIImage(named: "profileImage") ?? UIImage()
        )
    }

    fileprivate func setupGameGenreCollectionView() {
        gameGenreCollectionView.style {
            $0.tag = 0
            $0.backgroundColor = .clear
            $0.register(GameGenreCell.self, forCellWithReuseIdentifier: GameGenreCell.cellIdentifier)

            let layout = CenterAlignedCollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
            layout.estimatedItemSize = CGSize(width: 1, height: 1000)
            layout.scrollDirection = .vertical

            $0.setCollectionViewLayout(layout, animated: true)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets.zero
        }

        gameGenreView.style {
            $0.backgroundColor = UIColor(named: "CardColor") // UIColor(red: 31/255, green: 36/255, blue: 48/255, alpha: 1)
            $0.layer.cornerRadius = 16
        }
    }

    fileprivate func setupRecommendedView() {
        recommendedGameLbl.style {
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = UIColor(named: "TextColor")
            $0.text = "Games you must try"
        }

        recommendedGameView.style {
            $0.registerCell(cell: RecommendedGameCell.self, identifier: RecommendedGameCell.cellIdentifier)
            $0.setCellTag(tag: 1)
            $0.updateCollectionViewHeight(220)
            $0.collectionView.bounces = false

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
            $0.setCollectionViewFlowLayout(layout)
        }
    }

    fileprivate func setupPopularGamesView() {
        popularGamesLbl.style {
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = UIColor(named: "TextColor")
            $0.text = "Popular games"
        }

        popularGamesView.style {
            $0.registerCell(cell: GameCell.self, identifier: GameCell.cellIdentifier)
            $0.setCellTag(tag: 2)
            $0.collectionView.bounces = false

            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = 16
            layout.minimumLineSpacing = 16
            $0.setCollectionViewFlowLayout(layout)
        }
    }

    fileprivate func setupConstraints() {
        setupBaseConstraints()
        setupHeaderConstraints()
        setupGameGenreCollectionviewConstraints()
        setupRecommendedConstraints()
        setupPopularGamesConstraints()

        setNeedsLayout()
        layoutIfNeeded()
    }

    fileprivate func setupBaseConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }

    fileprivate func setupHeaderConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    fileprivate func setupGameGenreCollectionviewConstraints() {
        gameGenreView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        gameGenreCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0).priority(999)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.trailing.equalToSuperview()
        }
    }

    fileprivate func setupRecommendedConstraints() {
        recommendedView.snp.makeConstraints { make in
            make.top.equalTo(gameGenreView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
        }

        recommendedGameLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        recommendedGameView.snp.makeConstraints { make in
            make.top.equalTo(recommendedGameLbl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    fileprivate func setupPopularGamesConstraints() {
        popularGamesLbl.snp.makeConstraints { make in
            make.top.equalTo(recommendedView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }

        popularGamesView.snp.makeConstraints { make in
            make.top.equalTo(popularGamesLbl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
