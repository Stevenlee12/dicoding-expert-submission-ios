//
//  NetworkManager.swift
//  GameCenter
//
//  Created by Steven Lie on 19/08/21.
//

import UIKit
import Alamofire
import Combine

protocol NetworkManagerProtocol {
    func request<T: Codable>(router: APIAction?, session: Session?, type model: T.Type) -> AnyPublisher<T, Error>
}

class NetworkManager: NetworkManagerProtocol {
    func request<T>(router: APIAction?, session: Session?, type model: T.Type) -> AnyPublisher<T, Error> where T: Decodable, T: Encodable {
        guard let router = router else {
            return Fail(error: AFError.invalidURL(url: "Invalid Router"))
                .eraseToAnyPublisher()
        }
        
        return Future { promise in
            session?
                .request(router, interceptor: nil)
                .validate(statusCode: 200..<500)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        let decoder = JSONDecoder()
                        do {
                            let model = try decoder.decode(T.self, from: data)
                            promise(.success(model))
                        } catch {
                            promise(.failure(AFError.createURLRequestFailed(error: error)))
                        }
                    case .failure(let error):
                        promise(.failure(AFError.createURLRequestFailed(error: error)))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
