//
//  File.swift
//  GCProfile
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation
import GCCommon

public protocol ProfileUseCase {
    func retrieveActivitiesLog() -> ActivitiesLogResult
    func getUserData() -> UserModel
    func updateUserData(user: User)
}

public class ProfileInteractor: ProfileUseCase {
    private let repository: ActivitiesLogRepositoryProtocol
    
    public required init(repository: ActivitiesLogRepositoryProtocol) {
        self.repository = repository
    }
    
    public func retrieveActivitiesLog() -> ActivitiesLogResult {
        return repository.getActivitiesLog()
    }
    
    public func getUserData() -> UserModel {
        return repository.getUserData()
    }
    
    public func updateUserData(user: User) {
        return repository.updateUserData(user: user)
    }
}
