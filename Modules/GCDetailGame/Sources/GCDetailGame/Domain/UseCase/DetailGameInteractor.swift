//
//  DetailGameInteractor.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation
import GCCommon

public protocol DetailGameUseCase {
    func getGameDetail(gameId: Int) -> DetailGameResult
    func executeAddGameToFavorites(_ model: AddFavoriteGameModel)
    func executeRemoveFavoriteGame(byID id: Int)
    func executeAddActivityLog(_ model: AddActivityLogModel)
    func isFavoriteGameExist(id: Int) -> Bool
}

public class DetailGameInteractor: @preconcurrency DetailGameUseCase {
    private let repository: DetailGameRepositoryProtocol
    
    public required init(repository: DetailGameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getGameDetail(gameId: Int) -> DetailGameResult {
        repository.fetchGameById(id: gameId)
    }
    
    @MainActor
    public func executeAddGameToFavorites(_ model: AddFavoriteGameModel) {
        repository.addGameToFavorite(model)
    }
    
    @MainActor
    public func executeRemoveFavoriteGame(byID id: Int) {
        repository.removeFavoriteGame(byID: id)
    }
    
    @MainActor
    public func executeAddActivityLog(_ model: AddActivityLogModel) {
        repository.createActivityLog(model)
    }
    
    @MainActor
    public func isFavoriteGameExist(id: Int) -> Bool {
        repository.isFavoriteGameExist(id: id)
    }
    
}
