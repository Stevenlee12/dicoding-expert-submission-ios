//
//  Injection.swift
//  GCProfile
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation

public final class ProfileInjection: NSObject {
    private func provideProfileRepository() -> ActivitiesLogRepositoryProtocol {
        let remote: ActivitiesLogDataSource = ActivitiesLogDataSource.shared
        
        return ActivitiesLogRepository.shared(remote: remote)
    }
    
    public func provideActivitiesLog() -> ProfileUseCase {
        let repository = provideProfileRepository()
        
        return ProfileInteractor(repository: repository)
    }
}
