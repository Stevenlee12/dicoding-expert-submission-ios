//
//  RatingView.swift
//  GameCenter
//
//  Created by Steven Lie on 15/09/22.
//

import UIKit
import GCCommon

final class RatingView: UIView {
    fileprivate lazy var ratingLbl = UILabel().parent(view: self)
    fileprivate lazy var ratingSideView = UIView().parent(view: self)
    fileprivate lazy var starStackView = StarView().parent(view: ratingSideView)
    fileprivate lazy var totalReviewsRating = UILabel().parent(view: ratingSideView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupViews()
    }
    
    public func setupRating(rating: Double, totalReviews: Int) {
        ratingLbl.text = "\(rating)"
        totalReviewsRating.text = "\(totalReviews) reviews"
        starStackView.setRating(rating: Int(rating))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        ratingLbl.style {
            $0.font = .systemFont(ofSize: 52, weight: .bold)
            $0.textColor = .textColor
        }
        
        totalReviewsRating.style {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor =  .textColor.withAlphaComponent(0.7)
            $0.textAlignment = .left
        }
    }
    
    fileprivate func setupConstraints() {
        ratingLbl.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        ratingSideView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.leading.equalTo(ratingLbl.snp.trailing).offset(16)
        }
        
        starStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        totalReviewsRating.snp.makeConstraints { make in
            make.top.equalTo(starStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
