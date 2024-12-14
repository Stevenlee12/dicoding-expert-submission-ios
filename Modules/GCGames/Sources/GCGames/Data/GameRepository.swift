//
//  GameRepository.swift
//  GCGames
//
//  Created by Steven Lie on 06/12/24.
//

import Foundation
import Combine

public typealias GamesResult = AnyPublisher<[GameModel], Error>
public typealias FavoriteGamesResult = AnyPublisher<[FavoriteGameModel], Error>

public protocol GameRepositoryProtocol {
    func fetchGames() -> GamesResult
    func searchGames(matching searchQuery: String?) -> GamesResult
    func getFavoriteGames() -> FavoriteGamesResult
}

public final class GameRepository: NSObject, Sendable {
    public typealias GameInstance = (GameDataSource) -> GameRepository
    
    fileprivate let remote: GameDataSource
    
    private init(remote: GameDataSource) {
        self.remote = remote
    }

    nonisolated(unsafe) private static var _shared: GameRepository?
    private static let lock = NSLock()

    public static func shared(remote: GameDataSource) -> GameRepository {
        lock.lock()
        defer { lock.unlock() }

        if _shared == nil {
            _shared = GameRepository(remote: remote)
        }
        return _shared!
    }
}

extension GameRepository: @preconcurrency GameRepositoryProtocol {
    public func fetchGames() -> GamesResult {
        return remote.fetchGames()
            .map { GamesMapper.mapGameResponsesToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
    
    public func searchGames(matching searchQuery: String?) -> GamesResult {
        return remote.searchGames(matching: searchQuery)
            .map { GamesMapper.mapGameResponsesToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    public func getFavoriteGames() -> FavoriteGamesResult {
        return remote.retrieveFavoriteGames()
            .map { GamesMapper.mapFavoriteGamesResponseToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
}
