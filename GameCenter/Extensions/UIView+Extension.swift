//
//  UIView+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }

    public func setAsLine(height: Float = 1) {
        self.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        backgroundColor = .gray
    }

    func addoverlay(color: UIColor = .black, alpha: CGFloat = 0.2) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }

    @discardableResult
    func parent(view: UIView) -> Self {
        if let stackView = view as? UIStackView {
            stackView.addArrangedSubview(self)
        } else {
            view.addSubview(self)
        }
        return self
    }

    public func clearAllConstraints(for view: UIView? = nil) {
        for subview in (view ?? self).subviews where subview.subviews.count != 0 {
            clearAllConstraints(for: subview)
        }
        (view ?? self).snp.removeConstraints()
    }

    public func setLayer(cornerRadius: CGFloat? = nil, borderWidth width: CGFloat? = nil, borderColor color: UIColor? = nil) {
        setNeedsLayout()
        layoutIfNeeded()
        if let radius = cornerRadius {
            let size = (frame.width == 0 ? frame.height : frame.width) / 2
            layer.cornerRadius = (radius == 0 ? size : radius)
        } else {
            layer.cornerRadius = 0
        }

        if let width = width {
            layer.borderWidth = width
        }
        if let color = color {
            layer.borderColor = color.cgColor
        }
        layer.masksToBounds = true
    }

    public func createShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
