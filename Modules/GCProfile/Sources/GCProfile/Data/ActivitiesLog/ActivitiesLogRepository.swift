//
//  File.swift
//  GCProfile
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation
import Combine
import GCCommon

public typealias ActivitiesLogResult = AnyPublisher<[ActivityLogModel], Error>

public protocol ActivitiesLogRepositoryProtocol {
    func getActivitiesLog() -> ActivitiesLogResult
    func getUserData() -> UserModel
    func updateUserData(user: User)
}

public final class ActivitiesLogRepository: NSObject, Sendable {
    public typealias ActivitiesLogInstance = (ActivitiesLogDataSource) -> ActivitiesLogRepository
    
    fileprivate let remote: ActivitiesLogDataSource
    
    private init(remote: ActivitiesLogDataSource) {
        self.remote = remote
    }
    
    nonisolated(unsafe) private static var _shared: ActivitiesLogRepository?
    private static let lock = NSLock()

    public static func shared(remote: ActivitiesLogDataSource) -> ActivitiesLogRepository {
        lock.lock()
        defer { lock.unlock() }

        if _shared == nil {
            _shared = ActivitiesLogRepository(remote: remote)
        }
        return _shared!
    }
}

extension ActivitiesLogRepository: @preconcurrency ActivitiesLogRepositoryProtocol {
    @MainActor
    public func getActivitiesLog() -> ActivitiesLogResult {
        return remote.retrieveActivitiesLogData()
            .map { ActivitiesLogMapper.mapActivitiesLogResponseToDomains(input: $0) }
            .eraseToAnyPublisher()
    }
    
    public func getUserData() -> UserModel {
        return remote.getUserData()
    }
    
    public func updateUserData(user: User) {
        return remote.updateUserData(user: user)
    }
}
