//
//  ProfileView.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import UIKit
import SnapKit
import GCCommon

public final class ProfileView: UIView {
    private lazy var scrollView = UIScrollView().parent(view: self)
    private lazy var contentView = UIView().parent(view: scrollView)
    
    lazy var profileView = UIView().parent(view: contentView)
    private lazy var profileImage = UIImageView().parent(view: profileView)
    private lazy var profileInfoView = UIView().parent(view: profileView)
    private lazy var profileEditView = UIImageView().parent(view: profileView)
    lazy var nameLbl = UILabel().parent(view: profileInfoView)
    lazy var emailLbl = UILabel().parent(view: profileInfoView)
    
    private lazy var yourActivityLbl = UILabel().parent(view: contentView)
    
    lazy var activityLogView = CustomViewWithCollectionView().parent(view: contentView)
    
    var profileViewDidTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundColor
        
        setupConstraints()
        setupViews()
        setupInteractions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupInteractions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        profileView.addGestureRecognizer(tap)

    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer) {
        profileViewDidTapped?()
    }
    
    fileprivate func setupViews() {
        setupBaseViews()
        setupProfileView()
        setupActivityView()
    }
    
    fileprivate func setupBaseViews() {
        scrollView.style {
            $0.showsHorizontalScrollIndicator = false
            $0.bounces = true
        }
    }
    
    fileprivate func setupProfileView() {
        profileView.style {
            $0.backgroundColor = .cardColor
            $0.layer.cornerRadius = 8
            $0.isUserInteractionEnabled = true
        }
        
        profileImage.style {
            $0.setLayer(cornerRadius: 0)
            $0.backgroundColor = .lightGray
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.image = AssetResource.profileImage.render()
            $0.setLayer(cornerRadius: 0, borderWidth: 1, borderColor: .gray.withAlphaComponent(0.8))
        }
        
        nameLbl.style {
            $0.textColor = .textColor
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 22)
            $0.text = ""
        }
        
        emailLbl.style {
            $0.textColor = .textColor
            $0.textAlignment = .left
            $0.font = .systemFont(ofSize: 14)
            $0.text = ""
        }
        
        profileEditView.style {
            $0.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .textColor.withAlphaComponent(0.4)
        }
    }
    
    fileprivate func setupActivityView() {
        yourActivityLbl.style {
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
            $0.textAlignment = .left
            $0.textColor = .textColor
            $0.text = "Your Activities"
        }
        
        activityLogView.style {
            $0.backgroundColor = .clear
            $0.registerCell(cell: LogCell.self, identifier: LogCell.cellIdentifier)
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
        setupBaseConstraints()
        setupProfileViewConstraints()
        setupActivityConstraints()
        
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
    
    fileprivate func setupProfileViewConstraints() {
        profileView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        profileImage.snp.makeConstraints { make in
            make.size.equalTo(64)
            make.top.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        profileInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(16)
            make.trailing.lessThanOrEqualTo(profileEditView.snp.leading).offset(-8)
        }
        
        nameLbl.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
        
        emailLbl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(nameLbl.snp.bottom).offset(8)
        }
        
        profileEditView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    fileprivate func setupActivityConstraints() {
        yourActivityLbl.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        activityLogView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(yourActivityLbl.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
