//
//  File.swift
//  GCCommon
//
//  Created by Steven Lie on 11/12/24.
//

import UIKit

public enum AssetResource: String {
    case profileImage
    
    public func render() -> UIImage {
        return UIImage(named: self.rawValue, in: Bundle.module, compatibleWith: nil) ?? UIImage()
    }
}
