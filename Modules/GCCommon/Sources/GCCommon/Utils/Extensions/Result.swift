//
//  Result.swift
//  GCCommon
//
//  Created by Steven Lie on 09/12/24.
//

import Foundation

public enum Result<T> {
    case success(T?)
    case loading
    case failure(String)
}
