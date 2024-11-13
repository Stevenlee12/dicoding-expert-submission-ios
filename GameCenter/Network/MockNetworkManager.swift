//
//  MockNetworkManager.swift
//  GameCenter
//
//  Created by Steven Lie on 30/10/24.
//

import Foundation
import Combine
import Alamofire

class MockNetworkManager: NetworkManagerProtocol {
    
    var mockGames: Games?
    var mockError: Error?
    
    init(mockGames: Games? = nil, mockError: Error? = nil) {
        self.mockGames = mockGames
        self.mockError = mockError
    }
    
    func request<T>(router: APIAction?, session: Alamofire.Session?, type model: T.Type) -> AnyPublisher<T, Error> where T: Decodable, T: Encodable {
        if let mockError = mockError {
            return Fail(error: mockError).eraseToAnyPublisher()
        }
        
        if let mockGames = mockGames as? T {
            return Just(mockGames)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: AFError.explicitlyCancelled).eraseToAnyPublisher()
    }
}
