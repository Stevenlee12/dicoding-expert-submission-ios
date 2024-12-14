//
//  File.swift
//  GCProfile
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation
import Alamofire
import Combine

import GCCommon

public protocol ActivitiesLogDataSourceProtocol {
    func retrieveActivitiesLogData() -> AnyPublisher<[ActivitiesLog], Error>
    func getUserData() -> UserModel
    func updateUserData(user: User)
}

public final class ActivitiesLogDataSource: NSObject, Sendable {
    public static let shared = ActivitiesLogDataSource()
}

extension ActivitiesLogDataSource: @preconcurrency ActivitiesLogDataSourceProtocol {
    @MainActor
    public func retrieveActivitiesLogData() -> AnyPublisher<[ActivitiesLog], Error> {
        return Just(CoreDataManager.shared.fetchAllActivityLog())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public func getUserData() -> UserModel {
        return UserModel(
            name: UserDefault.name.load() as? String ?? "",
            email: UserDefault.email.load() as? String ?? ""
        )
    }
    
    public func updateUserData(user: User) {
        UserDefault.name.save(value: user.name)
        UserDefault.email.save(value: user.email)
    }
}
