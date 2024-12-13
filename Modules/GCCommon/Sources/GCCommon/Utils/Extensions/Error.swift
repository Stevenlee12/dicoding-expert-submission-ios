//
//  Error.swift
//  GCCommon
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation

public enum NetworkError: Error {
    case http(code: Int, message: String)
    case custom(code: Int, message: String)
}

public enum DataError: Error {
    case decodingFail(code: Int, message: String)
    case localStorageFail(code: Int, message: String)
    case custom(code: Int, message: String)
}

extension NetworkError {
    public static func requestFail(with code: Int) -> Self {
        return NetworkError.custom(code: code, message: "AF_PROCESS_ERROR".localized())
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .http(code, message):
            return "\("HTTP_ERROR_EXPLANATION".localized()): \(NSLocalizedString(message, comment: "")) (\(code))"

        case let .custom(code, message):
            return "\("CUSTOM_NETWORK_ERROR_EXPLANATION".localized()): \(NSLocalizedString(message, comment: "")) (\(code))"
        }
    }
}

extension DataError {
    public static func decoderError() -> Self {
        return DataError.decodingFail(code: -1, message: "AF_DECODER_FAIL".localized())
    }

    public static func dataEmpty() -> Self {
        return DataError.custom(code: 1, message: "LOCAL_STORAGE_EMPTY".localized())
    }
}
