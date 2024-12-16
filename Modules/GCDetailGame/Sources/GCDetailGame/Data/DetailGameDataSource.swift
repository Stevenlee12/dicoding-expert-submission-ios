//
//  DetailGameDataSource.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation
import Alamofire
import Combine

import Modularization_API_Package
import GCCommon

public protocol DetailGameDataSourceProtocol {
    func fetchGameById(id: Int) -> AnyPublisher<DetailGameResponse, Error>
    func executeAddGameToFavorites(_ model: FavoriteGameModel)
    func executeRemoveFavoriteGame(byID id: Int)
    func executeAddActivityLog(_ model: ActivityLogModel)
    func isFavoriteGameExist(id: Int) -> Bool
}

public final class DetailGameDataSource: NSObject, Sendable {
    public static let shared = DetailGameDataSource()
}

extension DetailGameDataSource: @preconcurrency DetailGameDataSourceProtocol {
    public func fetchGameById(id: Int) -> AnyPublisher<DetailGameResponse, Error> {
        return Future<DetailGameResponse, Error> { completion in
            if var urlComponent = URLComponents(string: Endpoints.Get.getGameById(id: id).url) {
                urlComponent.queryItems = [
                    URLQueryItem(name: "key", value: API.apiKey)
                ]
                if let url = urlComponent.url {
                    let decoder = JSONDecoder()
                    
                    AF.request(url)
                        .validate()
                        .responseDecodable(of: DetailGameResponse.self, decoder: decoder) { response in
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
    public func executeAddGameToFavorites(_ model: FavoriteGameModel) {
        let addFavGameModel = AddFavoriteGameModel(
            id: model.id,
            name: model.name,
            released: model.released,
            backgroundImage: model.backgroundImage,
            rating: model.rating,
            genres: model.genres
        )
        
        return CoreDataManager.shared.addFavoriteGame(model: addFavGameModel)
    }
    
    @MainActor
    public func executeRemoveFavoriteGame(byID id: Int) {
        return CoreDataManager.shared.deleteFavoriteGameById(id)
    }
    
    @MainActor
    public func executeAddActivityLog(_ model: ActivityLogModel) {
        let addActivityModel = AddActivityLogModel(
            id: model.id,
            gameImage: model.gameImage,
            activityStatus: model.activityStatus,
            gameTitle: model.gameTitle,
            date: model.date
        )
        
        return CoreDataManager.shared.addActivityLog(model: addActivityModel)
    }
    
    @MainActor
    public func isFavoriteGameExist(id: Int) -> Bool {
        return CoreDataManager.shared.isFavoriteGameExist(id)
    }
}
