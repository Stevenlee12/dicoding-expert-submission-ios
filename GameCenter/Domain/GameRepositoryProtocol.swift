//
//  GameRepositoryProtocol.swift
//  GameCenter
//
//  Created by Steven Lie on 01/11/24.
//

import Foundation
import Combine

typealias GamesResult = AnyPublisher<Games, Error>
typealias DetailGameResult = AnyPublisher<DetailGameModel, Error>

protocol GameRepositoryProtocol {
    func fetchGames(matching searchQuery: String?) -> GamesResult
    func fetchGame(byID id: Int) -> DetailGameResult
    func retrieveActivityLog() -> [ActivitiesLog]
    func retrieveFavoriteGames() -> [FavoriteGames]
    func createActivityLog(_ model: AddActivityLogModel)
    func addGameToFavorites(_ model: AddFavoriteGameModel)
    func removeFavoriteGame(byID id: Int)
}
