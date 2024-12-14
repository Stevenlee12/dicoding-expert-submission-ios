//
//  File.swift
//  GCGames
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation

public protocol SearchGamesUseCase {
    func getGames(matching searchQuery: String?) -> GamesResult
}

public class SearchGamesInteractor: SearchGamesUseCase {
    private let repository: GameRepositoryProtocol
    
    public required init(repository: GameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getGames(matching searchQuery: String?) -> GamesResult {
        return repository.searchGames(matching: searchQuery)
    }
}
