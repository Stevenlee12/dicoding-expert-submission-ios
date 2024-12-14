//
//  TrendingGamesInteractor.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation

public protocol TrendingGamesUseCase {
    func getTrendingGames() -> GamesResult
}

public class TrendingGamesInteractor: TrendingGamesUseCase {
    private let repository: GameRepositoryProtocol
    
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getTrendingGames() -> GamesResult {
        return repository.fetchGames()
    }
}
