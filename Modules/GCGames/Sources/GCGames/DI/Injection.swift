//
//  Injection.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation

public final class GameInjection: NSObject {
    private func provideGameRepository() -> GameRepositoryProtocol {
        let remote: GameDataSource = GameDataSource.shared
        
        return GameRepository.shared(remote: remote)
    }
    
    public func provideTrendingGames() -> TrendingGamesUseCase {
        let repository = provideGameRepository()
        
        return TrendingGamesInteractor(repository: repository)
    }
    
    public func provideSearchGames() -> SearchGamesUseCase {
        let repository = provideGameRepository()
        
        return SearchGamesInteractor(repository: repository)
    }
    
    public func provideFavoriteGames() -> FavoriteGamesUseCase {
        let repository = provideGameRepository()
        
        return FavoriteGamesInteractor(repository: repository)
    }
}
