//
//  UIScrollView+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 16/08/21.
//

import UIKit
import Stevia

extension UIScrollView {
    public var content: UIView! {
        guard subviews.count != 0 else {
            addContentView(view: UIView())
            return subviews[0]
        }
        return subviews[0]
    }

    public func addContentView(view: UIView) {
        if subviews.count == 0 {
            addSubview(view)
            subviews[0].translatesAutoresizingMaskIntoConstraints = false

            // Set constraints
            NSLayoutConstraint.activate([
                subviews[0].topAnchor.constraint(equalTo: self.topAnchor),
                subviews[0].leadingAnchor.constraint(equalTo: self.leadingAnchor),
                subviews[0].trailingAnchor.constraint(equalTo: self.trailingAnchor),
                subviews[0].bottomAnchor.constraint(equalTo: self.bottomAnchor),
                subviews[0].widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        } else {
//            debug(key: "this scrollview already have contentView", subviews)
        }
    }

    public func addScrollViewVisualEffect(style: UIBlurEffect.Style = .extraLight, frame: CGRect? = nil, animated: Bool, duration: TimeInterval = 0.5) {
        // make sure that you've already set
        // the view's constraint before called this function
        setNeedsLayout()
        layoutIfNeeded()
        if viewWithTag(208283) == nil {
            let blurEffect = UIBlurEffect(style: style)
            let visualEffect = UIVisualEffectView(effect: blurEffect)
            visualEffect.tag = 208283
            visualEffect.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(visualEffect)
        }
        let visualEffect = viewWithTag(208283)!
        let size = (contentSize.height < self.frame.size.height) ? self.frame.size : contentSize
        visualEffect.frame = CGRect(origin: CGPoint.zero, size: size)
        if animated {
            visualEffect.alpha = 0
            UIView.animate(withDuration: duration) {
                visualEffect.alpha = 1
            }
        }
    }

    public func hideScrollViewVisualEffect(animated: Bool, duration: TimeInterval = 0.5) {
        if let visualView = viewWithTag(208283) {
            if animated {
                UIView.animate(withDuration: duration, animations: {
                    visualView.alpha = 0
                }, completion: { _ in
                    visualView.removeFromSuperview()
                })
            } else {
                visualView.removeFromSuperview()
            }
        }
    }

    public var currentIndex: Int {
        return Int(contentOffset.x / frame.size.width)
    }

    public func isReachTopView(_ offset: CGFloat = 0) -> Bool {
        return self.contentOffset.y <= 0
    }

    public func isReachBottomView(_ offset: CGFloat = 0) -> Bool {
        setNeedsLayout()
        layoutIfNeeded()
        guard self.contentSize.height > frame.size.height else {
            return false
        }
        let currentOffset = self.contentOffset.y
        let maximumOffset = self.contentSize.height - frame.size.height + offset
        return (currentOffset >= maximumOffset) && (maximumOffset > 0) && (currentOffset > 0)
    }

    public func isReachBottomView(offset: CGFloat = 0, hasData: Bool, requesting: Bool) -> Bool {
        return isReachBottomView(offset) && hasData && !requesting
    }

    public func automaticallyAdjustsContentSize() {
        heightConstraint?.constant = CGFloat.greatestFiniteMagnitude
        layoutIfNeeded()
        heightConstraint?.constant = contentSize.height + contentInset.top + contentInset.bottom
    }

    public func getCleanBounds() -> CGSize {
        let width = bounds.width - contentInset.left - contentInset.right
        let height = bounds.height - contentInset.top - contentInset.bottom
        return CGSize(width: width, height: height)
    }
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    public func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
           // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
           // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
       }
    }

    // Bonus: Scroll to top
    public func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    public func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
