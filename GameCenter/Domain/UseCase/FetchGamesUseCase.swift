//
//  FetchGamesUseCase.swift
//  GameCenter
//
//  Created by Steven Lie on 01/11/24.
//

import Foundation

final class FetchGamesUseCase: FetchGamesUseCaseProtocol {
    private let repository: GameRepositoryProtocol

    init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    func executeFetchGames(matching searchQuery: String?) -> GamesResult {
        repository.fetchGames(matching: searchQuery)
    }
    
    func executeFetchGameDetail(byID id: Int) -> DetailGameResult {
        repository.fetchGame(byID: id)
    }
    
    func retrieveActivityLog() -> [ActivitiesLog] {
        repository.retrieveActivityLog()
    }
    
    func retrieveFavoriteGames() -> [FavoriteGames] {
        repository.retrieveFavoriteGames()
    }
    
    func executeAddActivityLog(_ model: AddActivityLogModel) {
        repository.createActivityLog(model)
    }
    
    func executeAddGameToFavorites(_ model: AddFavoriteGameModel) {
        repository.addGameToFavorites(model)
    }
    
    func executeRemoveFavoriteGame(byID id: Int) {
        repository.removeFavoriteGame(byID: id)
    }
    
}
