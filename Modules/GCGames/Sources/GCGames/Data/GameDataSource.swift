//
//  GameDataSource.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation
import Alamofire
import Combine

import Modularization_API_Package
import GCCommon

public protocol GameDataSourceProtocol {
    func fetchGames() -> AnyPublisher<GamesResponse, Error>
    func searchGames(matching searchQuery: String?) -> AnyPublisher<GamesResponse, Error>
    func retrieveFavoriteGames() -> AnyPublisher<[FavoriteGames], Error>
}

public final class GameDataSource: NSObject, Sendable {
    public static let shared = GameDataSource()
}

extension GameDataSource: @preconcurrency GameDataSourceProtocol {
    public func fetchGames() -> AnyPublisher<GamesResponse, Error> {
        return Future<GamesResponse, Error> { completion in
            if var urlComponent = URLComponents(string: Endpoints.Get.getGames.url) {
                urlComponent.queryItems = [
                    URLQueryItem(name: "key", value: API.apiKey)
                ]
                if let url = urlComponent.url {
                    let decoder = JSONDecoder()
                    
                    AF.request(url)
                        .validate()
                        .responseDecodable(of: GamesResponse.self, decoder: decoder) { response in
                            switch response.result {
                            case .success(let response):
                                completion(.success(response))
                            case .failure(let error):
                                if error.isResponseSerializationError {
                                    completion(.failure(DataError.decoderError()))
                                } else {
                                    completion(.failure(
                                        NetworkError.requestFail(with: error.responseCode ?? -1))
                                    )
                                }
                            }
                        }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func searchGames(matching searchQuery: String?) -> AnyPublisher<GamesResponse, Error> {
        return Future<GamesResponse, Error> { completion in
            if var urlComponent = URLComponents(string: Endpoints.Get.searchGames(query: searchQuery).url) {
                urlComponent.queryItems?.append(URLQueryItem(name: "key", value: API.apiKey))
                
                if let url = urlComponent.url {
                    let decoder = JSONDecoder()
                    
                    AF.request(url)
                        .validate()
                        .responseDecodable(of: GamesResponse.self, decoder: decoder) { response in
                            switch response.result {
                            case .success(let response):
                                completion(.success(response))
                            case .failure(let error):
                                if error.isResponseSerializationError {
                                    completion(.failure(DataError.decoderError()))
                                } else {
                                    completion(.failure(
                                        NetworkError.requestFail(with: error.responseCode ?? -1))
                                    )
                                }
                            }
                        }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    @MainActor
    public func retrieveFavoriteGames() -> AnyPublisher<[FavoriteGames], Error> {
        return Just(CoreDataManager.shared.fetchAllFavoriteGame())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
