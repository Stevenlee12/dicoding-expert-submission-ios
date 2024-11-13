//
//  GameGenreCell.swift
//  GameCenter
//
//  Created by Steven Lie on 12/09/22.
//

import UIKit

struct GameGenreModel {
    let id: Int
    let genre: String
    let image: String
}

final class GameGenreCell: UICollectionViewCell {
    static let cellIdentifier = "cellIdentifier"

    lazy var gameGenreLogo = UIImageView().parent(view: contentView)
    lazy var gameGenreLbl = UILabel().parent(view: contentView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        setupConstraints()
        setupCell()
    }

    var model: GameGenreModel? {
        didSet {
            guard let model = model else { return }
            gameGenreLogo.image = UIImage(named: model.image)
            gameGenreLbl.text = model.genre
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        gameGenreLogo.style {
            $0.contentMode = .scaleAspectFit
        }

        gameGenreLbl.style {
            $0.font = .systemFont(ofSize: 13)
            $0.textColor = UIColor(named: "TextColor")?.withAlphaComponent(0.8)
        }
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.fixedCoordinateSpace.bounds.width / 5.5)
        }

        gameGenreLogo.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.top.leading.trailing.equalToSuperview()
        }

        gameGenreLbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gameGenreLogo.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}
