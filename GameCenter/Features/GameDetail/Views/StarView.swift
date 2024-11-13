//
//  StarView.swift
//  GameCenter
//
//  Created by Steven Lie on 15/09/22.
//

import UIKit

final class StarView: UIView {
    fileprivate lazy var starStackView = UIStackView().parent(view: self)
    fileprivate lazy var firstStar = UIImageView().parent(view: starStackView)
    fileprivate lazy var secondStar = UIImageView().parent(view: starStackView)
    fileprivate lazy var thirdStar = UIImageView().parent(view: starStackView)
    fileprivate lazy var fourthStar = UIImageView().parent(view: starStackView)
    fileprivate lazy var fifthStar = UIImageView().parent(view: starStackView)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setRating(rating: Int) {
        let stars = [firstStar, secondStar, thirdStar, fourthStar, fifthStar]
        
        for index in 0 ..< rating {
            stars[index].tintColor = UIColor.init(hexa: 0xFCC672)
        }
    }
    
    fileprivate func setupViews() {
        starStackView.style {
            $0.axis = .horizontal
            $0.spacing = 4
        }
        
        [firstStar, secondStar, thirdStar, fourthStar, fifthStar].style {
            $0.image = UIImage(systemName: "star.fill")
            $0.tintColor = UIColor.init(hexa: 0x44454D)
        }
    }
    
    fileprivate func setupConstraints() {
        starStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        firstStar.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        secondStar.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        thirdStar.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        fourthStar.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        
        fifthStar.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(22)
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
