//
//  Result.swift
//  GameCenter
//
//  Created by Steven Lie on 29/10/24.
//

import Foundation

enum Result<T> {
    case success(T?)
    case loading
    case failure(String)
}
