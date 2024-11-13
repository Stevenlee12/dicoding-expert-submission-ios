//
//  FetchGamesUseCaseProtocol.swift
//  GameCenter
//
//  Created by Steven Lie on 01/11/24.
//

import Foundation

protocol FetchGamesUseCaseProtocol {
    func executeFetchGames(matching searchQuery: String?) -> GamesResult
    func executeFetchGameDetail(byID id: Int) -> DetailGameResult
    func retrieveActivityLog() -> [ActivitiesLog]
    func retrieveFavoriteGames() -> [FavoriteGames]
    func executeAddActivityLog(_ model: AddActivityLogModel)
    func executeAddGameToFavorites(_ model: AddFavoriteGameModel)
    func executeRemoveFavoriteGame(byID id: Int)
}
