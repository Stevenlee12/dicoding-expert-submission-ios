//
//  GameRepository.swift
//  GameCenter
//
//  Created by Steven Lie on 01/11/24.
//

import Foundation
import Combine
import Alamofire

final class GameRepository: GameRepositoryProtocol {
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchGames(matching searchQuery: String?) -> GamesResult {
        let router = APIAction.getGames(id: nil, searchQuery: searchQuery)
        
        return networkManager
            .request(router: router, session: .default, type: Games.self)
            .eraseToAnyPublisher()
    }
    
    func fetchGame(byID id: Int) -> DetailGameResult {
        let router = APIAction.getGames(id: id, searchQuery: nil)
        
        return networkManager
            .request(router: router, session: .default, type: DetailGameModel.self)
            .eraseToAnyPublisher()
    }
    
    func retrieveActivityLog() -> [ActivitiesLog] {
        return CoreDataManager.fetchAllActivityLog()
    }
    
    func retrieveFavoriteGames() -> [FavoriteGames] {
        return CoreDataManager.fetchAllFavoriteGame()
    }
    
    func createActivityLog(_ model: AddActivityLogModel) {
        return CoreDataManager.addActivityLog(model: model)
    }
    
    func addGameToFavorites(_ model: AddFavoriteGameModel) {
        return CoreDataManager.addFavoriteGame(model: model)
    }
    
    func removeFavoriteGame(byID id: Int) {
        return CoreDataManager.deleteFavoriteGameById(id)
    }
}
