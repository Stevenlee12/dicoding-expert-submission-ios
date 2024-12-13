//
//  UIImageView+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 13/09/22.
//

import Foundation
import Photos
import UIKit
import Kingfisher

extension UIImageView {
    public func setRounded() {
        let radius = 25
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }

    public func setImage(string: String?) {
        guard let string = string,
              let url = string.getCleanedURL()
        else {
            self.image = UIImage(named: "brokenImage")
            return
        }

        let imageResource = KF.ImageResource(downloadURL: url)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imageResource)
    }

    public func setImage(url: URL?) {
        guard let url = url
        else {
            self.image = UIImage(named: "brokenImage")
            return
        }

        let imageResource = KF.ImageResource(downloadURL: url)
        self.kf.indicatorType = .activity
        self.kf.setImage(with: imageResource)
    }
}
