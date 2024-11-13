//
//  GameCell.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit

final class GameCell: UICollectionViewCell {
    static let cellIdentifier = "cellIdentifier"
    lazy var gameLogo = UIImageView().parent(view: contentView)

    lazy var descriptionView = UIView().parent(view: contentView)

    lazy var gameTitleLbl = UILabel().parent(view: descriptionView)
    lazy var ratingView = UIView().parent(view: descriptionView)
    lazy var ratingImage = UIImageView().parent(view: ratingView)
    lazy var ratingLbl = UILabel().parent(view: ratingView)
    lazy var genreLbl = UILabel().parent(view: descriptionView)
    lazy var releaseAtLbl = UILabel().parent(view: descriptionView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        setupConstraints()
        setupCell()
    }

    var model: GameModel? {
        didSet {
            guard let model = model else { return }
            let logo = model.backgroundImage ?? ""
            gameTitleLbl.text = model.name ?? "No Name"
            ratingLbl.text = "\(model.rating?.rounded(toPlaces: 1) ?? 0.0)"
            gameLogo.setImage(string: logo)

            let genres = model.genres ?? [Genre]()
            let gameGenres = genres.map({ $0.name ?? "" }).joined(separator: ", ")
            genreLbl.text = gameGenres
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let releaseDate = dateFormatter.date(from: model.released ?? "") {
                dateFormatter.dateFormat = "E, d MMM yyyy"
                let formattedDate = dateFormatter.string(from: releaseDate)
                releaseAtLbl.text = "Released on " + formattedDate
            }
        }
    }
    
    var favGameModel: FavoriteGames? {
        didSet {
            guard let model = favGameModel else { return }
            let logo = model.backgroundImage ?? ""
            gameTitleLbl.text = model.name ?? "No Name"
            ratingLbl.text = "\(model.rating.rounded(toPlaces: 1))"
            gameLogo.setImage(string: logo)

            genreLbl.text = model.genres
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            if let releaseDate = dateFormatter.date(from: model.released ?? "") {
                dateFormatter.dateFormat = "E, d MMM yyyy"
                let formattedDate = dateFormatter.string(from: releaseDate)
                releaseAtLbl.text = "Released on " + formattedDate
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {

        gameLogo.style {
            $0.setLayer(cornerRadius: 16)
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        gameTitleLbl.style {
            $0.textColor = UIColor(named: "TextColor")?.withAlphaComponent(0.9)
            $0.font = .systemFont(ofSize: 15, weight: .medium)
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }

        ratingImage.style {
            $0.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = UIColor.init(hexa: 0xFCC672)
        }

        ratingLbl.style {
            $0.textColor = UIColor.init(hexa: 0xFCC672)
            $0.font = .systemFont(ofSize: 13)
            $0.textAlignment = .left
        }

        [genreLbl, releaseAtLbl].style {
            $0.textColor = .lightGray
            $0.textAlignment = .left
        }
        
        genreLbl.font = .systemFont(ofSize: 13)
        releaseAtLbl.font = .systemFont(ofSize: 11)
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameLogo.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(96)
        }

        descriptionView.snp.makeConstraints { make in
            make.leading.equalTo(gameLogo.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }

        gameTitleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        releaseAtLbl.snp.makeConstraints { make in
            make.top.equalTo(gameTitleLbl.snp.bottom).offset(4)
            make.trailing.leading.equalTo(gameTitleLbl)
        }

        genreLbl.snp.makeConstraints { make in
            make.top.equalTo(releaseAtLbl.snp.bottom).offset(8)
            make.leading.trailing.equalTo(gameTitleLbl)
        }

        ratingView.snp.makeConstraints { make in
            make.top.equalTo(genreLbl.snp.bottom).offset(8)
            make.trailing.leading.bottom.equalToSuperview()
        }

        ratingImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(18)
        }

        ratingLbl.snp.makeConstraints { make in
            make.leading.equalTo(ratingImage.snp.trailing).offset(4)
            make.top.trailing.bottom.equalToSuperview()
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}
