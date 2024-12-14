//
//  FavoriteGamesInteractor.swift
//  GCGames
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation

public protocol FavoriteGamesUseCase {
    func retrieveFavoriteGames() -> FavoriteGamesResult
}

public class FavoriteGamesInteractor: FavoriteGamesUseCase {
    private let repository: GameRepositoryProtocol
    
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func retrieveFavoriteGames() -> FavoriteGamesResult {
        return repository.getFavoriteGames()
    }
}
