//
//  File.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import UIKit
import SnapKit

import GCCommon
import GCDetailGame

final class GameDetailView: UIView {
    lazy var scrollView = UIScrollView().parent(view: self)
    fileprivate lazy var contentView = UIView().parent(view: scrollView)
    
    lazy var backgroundImg = UIImageView().parent(view: scrollView)
    lazy var backBtn = UIButton().parent(view: self)
    fileprivate lazy var gameLogo = UIImageView().parent(view: contentView)
    fileprivate lazy var gameTitle = UILabel().parent(view: contentView)
    
    lazy var emptyView = UIView().parent(view: contentView)
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 28)
    fileprivate lazy var genreLbl = UILabel().parent(view: contentView)
    fileprivate lazy var favoriteBtn = UIButton().parent(view: contentView)
    lazy var shortMsg = UILabel().parent(view: contentView)
    
    fileprivate lazy var loadingView = UILabel().parent(view: self)
    
    fileprivate lazy var aboutTitleLbl = UILabel().parent(view: contentView)
    fileprivate lazy var aboutText = ExpendableLabel().parent(view: contentView)
    
    fileprivate lazy var ratingTitleLbl = UILabel().parent(view: contentView)
    fileprivate lazy var ratingView = RatingView().parent(view: contentView)
    
    let windowEdge = UIApplication.shared.windows.first
    
    var backBtnDidTapped: (() -> Void)?
    var favBtnDidTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupViews()
        setupInteractions()
    }
    
    public func setData(data: DetailGameModel) {
        backgroundImg.setImage(string: data.backgroundImageAdditional ?? "")
        gameLogo.setImage(string: data.backgroundImage ?? "")
        gameTitle.text = data.name
        
        let genres = data.genres ?? [GenreModel]()
        let gameGenres = genres.map({ $0.name ?? "" }).joined(separator: ", ")
        genreLbl.text = gameGenres
        aboutText.setLabelText(text: data.description ?? "No description")
        
        ratingView.setupRating(
            rating: data.rating?.rounded(toPlaces: 1) ?? 0.0,
            totalReviews: data.ratings?.reduce(0) {
                $0 + ($1.count ?? 0)
            } ?? 0
        )
    }
    
    public func setFavoriteButton(_ isFav: Bool) {
        var bgColor: UIColor
        var btnText: String
        var msgText: String
        
        if isFav {
            bgColor = .baseColor
            btnText = "ADDED!"
            msgText = "Added to\nFavorite!"
        } else {
            bgColor = .systemBlue
            btnText = "ADD"
            msgText = "Add to\nFavorite"
        }
        
        favoriteBtn.backgroundColor = bgColor
        favoriteBtn.setTitle(btnText, for: .normal)
        shortMsg.text = msgText
    }
    
    public func isLoading(_ isLoading: Bool) {
        loadingView.isHidden = !isLoading
        contentView.isHidden = isLoading
    }
    
    fileprivate func setupInteractions() {
        backBtn.addTarget(self, action: #selector(backBtnTappedHandler), for: .touchUpInside)
        favoriteBtn.addTarget(self, action: #selector(favBtnTappedHandler), for: .touchUpInside)
    }
    
    @objc fileprivate func backBtnTappedHandler() {
        backBtnDidTapped?()
    }
    
    @objc fileprivate func favBtnTappedHandler() {
        favBtnDidTapped?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViews() {
        setupBaseViews()
        setupHeaderViews()
        setupGameDescriptionView()
    }

    fileprivate func setupBaseViews() {
        scrollView.style {
            $0.bounces = true
            $0.contentInsetAdjustmentBehavior = .never
            $0.alwaysBounceVertical = true
        }
        
        backBtn.style {
            $0.setImage(
                UIImage(
                    systemName: "chevron.left.circle.fill",
                    withConfiguration: self.largeConfig
                ), for: .normal
            )
            $0.contentMode = .scaleAspectFill
            $0.tintColor = .white
        }
        
        loadingView.style {
            $0.textColor = UIColor(red: 250/255, green: 30/255, blue: 78/255, alpha: 1)
            $0.textAlignment = .center
            $0.isHidden = true
            $0.font = .systemFont(ofSize: 12)
            $0.text = "Getting your data..."
        }
    }
    
    fileprivate func setupHeaderViews() {
        backgroundImg.style {
            $0.backgroundColor = .backgroundColor
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.addoverlay()
        }
    }
    
    fileprivate func setupGameDescriptionView() {
        gameLogo.style {
            $0.backgroundColor = .lightGray
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 24
        }
        
        gameTitle.style {
            $0.font = .systemFont(ofSize: 22, weight: .bold)
            $0.textColor = .textColor
            $0.numberOfLines = 0
        }
        
        genreLbl.style {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor =  .textColor.withAlphaComponent(0.7)
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.lineBreakMode = .byTruncatingTail
        }
        
        favoriteBtn.style {
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 24, bottom: 4, right: 24)
            $0.sizeToFit()
            $0.setTitle("ADD", for: .normal)
            $0.setLayer(cornerRadius: 12)
            $0.backgroundColor = .systemBlue
        }
        
        shortMsg.style {
            $0.text = "Add to\nFavorite"
            $0.font = .systemFont(ofSize: 8)
            $0.textColor = .lightGray
            $0.numberOfLines = 0
        }
        
        [aboutTitleLbl, ratingTitleLbl].style {
            $0.font = .systemFont(ofSize: 16, weight: .semibold)
            $0.textColor = .textColor
            $0.textAlignment = .left
        }
        
        aboutTitleLbl.text = "About"
        ratingTitleLbl.text = "Ratings"
    }

    fileprivate func setupConstraints() {
        setupBaseConstraints()
        setupHeaderConstraints()
        setupGameDescriptionConstraints()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    fileprivate func setupBaseConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(windowEdge?.safeAreaInsets.top ?? 0)
            make.leading.equalToSuperview().offset(16)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImg.snp.bottom)
            make.leading.trailing.bottom.width.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    fileprivate func setupHeaderConstraints() {
        backgroundImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    fileprivate func setupGameDescriptionConstraints() {
        gameLogo.snp.makeConstraints { make in
            make.top.equalTo(backgroundImg.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(128)
        }
        
        gameTitle.snp.makeConstraints { make in
            make.top.equalTo(backgroundImg.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(gameLogo.snp.trailing).offset(16)
        }
        
        genreLbl.snp.makeConstraints { make in
            make.top.equalTo(gameTitle.snp.bottom).offset(4)
            make.leading.trailing.equalTo(gameTitle)
        }
        
        favoriteBtn.snp.makeConstraints { make in
            make.bottom.equalTo(gameLogo)
            make.leading.equalTo(gameTitle)
        }
        
        shortMsg.snp.makeConstraints { make in
            make.centerY.equalTo(favoriteBtn)
            make.leading.equalTo(favoriteBtn.snp.trailing).offset(8)
        }
        
        aboutTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(gameLogo.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        aboutText.snp.makeConstraints { make in
            make.top.equalTo(aboutTitleLbl.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        ratingTitleLbl.snp.makeConstraints { make in
            make.top.equalTo(aboutText.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        ratingView.snp.makeConstraints { make in
            make.top.equalTo(ratingTitleLbl.snp.bottom).offset(8)
            make.leading.trailing.equalTo(ratingTitleLbl)
            make.bottom.equalToSuperview().offset(-32)
        }
    }
}
