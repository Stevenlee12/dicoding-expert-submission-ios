//
//  APIRouter.swift
//  GameCenter
//
//  Created by Steven Lie on 12/09/22.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var actionParameters: [String: Any] { get }
    var baseURL: String { get }
    var authHeader: HTTPHeaders? { get }
}

extension APIRouter {
    func asURLRequest() throws -> URLRequest {
        let requestURL = baseURL.appending(path)
        let originalRequest = try URLRequest(url: requestURL,
                                             method: method,
                                             headers: authHeader)

        let encodedRequest = try URLEncoding.default.encode(originalRequest,
                                                 with: actionParameters)

        return encodedRequest
    }
}
