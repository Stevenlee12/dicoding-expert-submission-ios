//
//  Double+Extension.swift
//  GameCenter
//
//  Created by Steven Lie on 15/09/22.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    public func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
