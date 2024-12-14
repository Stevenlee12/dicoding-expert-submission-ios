//
//  DetailGameRepository.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation
import Combine

import GCCommon

public typealias DetailGameResult = AnyPublisher<DetailGameModel, Error>

public protocol DetailGameRepositoryProtocol {
    func fetchGameById(id: Int) -> DetailGameResult
    func addGameToFavorite(_ model: AddFavoriteGameModel)
    func removeFavoriteGame(byID id: Int)
    func createActivityLog(_ model: AddActivityLogModel)
    func isFavoriteGameExist(id: Int) -> Bool
}

public final class DetailGameRepository: NSObject, Sendable {
    public typealias DetailGameInstance = (DetailGameDataSource) -> DetailGameRepository
    
    fileprivate let remote: DetailGameDataSource
    
    private init(remote: DetailGameDataSource) {
        self.remote = remote
    }

    nonisolated(unsafe) private static var _shared: DetailGameRepository?
    private static let lock = NSLock()

    public static func shared(remote: DetailGameDataSource) -> DetailGameRepository {
        lock.lock()
        defer { lock.unlock() }

        if _shared == nil {
            _shared = DetailGameRepository(remote: remote)
        }
        return _shared!
    }
}

extension DetailGameRepository: @preconcurrency DetailGameRepositoryProtocol {
    
    public func fetchGameById(id: Int) -> DetailGameResult {
        return remote.fetchGameById(id: id)
            .map { DetailGameMapper.mapDetailGameResponseToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
    
    @MainActor
    public func addGameToFavorite(_ model: AddFavoriteGameModel) {
        return remote.executeAddGameToFavorites(model)
    }
    
    @MainActor
    public func removeFavoriteGame(byID id: Int) {
        return remote.executeRemoveFavoriteGame(byID: id)
    }
    
    @MainActor
    public func createActivityLog(_ model: AddActivityLogModel) {
        return remote.executeAddActivityLog(model)
    }
    
    @MainActor
    public func isFavoriteGameExist(id: Int) -> Bool {
        return remote.isFavoriteGameExist(id: id)
    }
}
