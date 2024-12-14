//
//  RecommendedGameCell.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import UIKit
import GCGames
import SnapKit

public final class RecommendedGameCell: UICollectionViewCell {
    static let cellIdentifier = "cellIdentifier"

    lazy var containerView = UIView().parent(view: contentView)
    lazy var gameBackgroundImg = UIImageView().parent(view: containerView)
    lazy var gameFooterView = UIView().parent(view: containerView)

    lazy var gameLogo = UIImageView().parent(view: gameFooterView)
    lazy var descriptionView = UIView().parent(view: gameFooterView)

    lazy var gameTitleLbl = UILabel().parent(view: descriptionView)
    lazy var ratingView = UIView().parent(view: descriptionView)
    lazy var ratingImage = UIImageView().parent(view: ratingView)
    lazy var ratingLbl = UILabel().parent(view: ratingView)
    lazy var genreLbl = UILabel().parent(view: ratingView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        setupConstraints()
        setupCell()
    }

    var model: GameModel? {
        didSet {
            guard let model = model else { return }
            let backgroundImage = model.backgroundImage ?? ""
            let logo = model.shortScreenshots?.last?.image ?? backgroundImage
            gameBackgroundImg.setImage(string: backgroundImage)
            gameTitleLbl.text = model.name ?? "No Name"
            ratingLbl.text = "\(model.rating?.rounded(toPlaces: 1) ?? 0.0)"
            gameLogo.setImage(string: logo)
            genreLbl.text = " • " + (model.genres?.first?.name ?? "")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        gameBackgroundImg.style {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.addoverlay()
        }

        containerView.style {
            $0.backgroundColor = UIColor(named: "CardColor") // .init(hexa: 0x0A101D)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
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

        gameLogo.style {
            $0.backgroundColor = .init(hexa: 0x44454D)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        genreLbl.style {
            $0.textColor = .lightGray
            $0.font = .systemFont(ofSize: 13)
            $0.textAlignment = .left
        }
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(200)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameBackgroundImg.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(200 * 0.6)
        }

        gameFooterView.snp.makeConstraints { make in
            make.top.equalTo(gameBackgroundImg.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        gameLogo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(48)
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

        ratingView.snp.makeConstraints { make in
            make.top.equalTo(gameTitleLbl.snp.bottom).offset(4)
            make.leading.trailing.equalTo(gameTitleLbl)
            make.bottom.equalToSuperview()
        }

        ratingImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.height.equalTo(16)
            make.width.equalTo(18)
        }

        ratingLbl.snp.makeConstraints { make in
            make.leading.equalTo(ratingImage.snp.trailing).offset(4)
            make.top.bottom.equalToSuperview()
        }

        genreLbl.snp.makeConstraints { make in
            make.leading.equalTo(ratingLbl.snp.trailing).offset(4)
            make.top.bottom.trailing.equalToSuperview()
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}
