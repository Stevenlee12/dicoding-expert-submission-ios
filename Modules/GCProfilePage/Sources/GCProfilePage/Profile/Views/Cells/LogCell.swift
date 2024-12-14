//
//  LogCell.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import UIKit
import GCCommon
import GCProfile

final class LogCell: UICollectionViewCell {
    static let cellIdentifier = "cellIdentifier"
    fileprivate lazy var gameLogo = UIImageView().parent(view: contentView)

    fileprivate lazy var descriptionView = UIView().parent(view: contentView)

    fileprivate lazy var statusLbl = UILabel().parent(view: descriptionView)
    fileprivate lazy var dateLbl = UILabel().parent(view: descriptionView)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        setupConstraints()
        setupCell()
    }

    var model: ActivityLogModel? {
        didSet {
            guard let model = model else { return }
            let logo = model.gameImage ?? ""
            gameLogo.setImage(string: logo)

            var status = ""

            if Int(model.activityStatus ?? -1) == 0 {
                status = "You removed \(model.gameTitle ?? "") game from favorite."
            } else {
                status = "You added \(model.gameTitle ?? "") game to favorite."
            }

            statusLbl.text = status

            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MMM d, h:mm a"

            guard let date = model.date else { return }
            let logTime = dateFormatterGet.string(from: date)
            dateLbl.text = logTime
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {

        gameLogo.style {
            $0.setLayer(cornerRadius: 0)
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
        }

        statusLbl.style {
            $0.textColor = .textColor.withAlphaComponent(0.9)
            $0.font = .systemFont(ofSize: 12)
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }

        dateLbl.style {
            $0.textColor = .lightGray
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 12)
        }
    }

    private func setupConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        gameLogo.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(56)
        }

        descriptionView.snp.makeConstraints { make in
            make.leading.equalTo(gameLogo.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        statusLbl.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        dateLbl.snp.makeConstraints { make in
            make.top.equalTo(statusLbl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        setNeedsLayout()
        layoutIfNeeded()
    }
}
