//
//  File.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation

public final class DetailGameInjection: NSObject {
    private func provideDetailGameRepository() -> DetailGameRepositoryProtocol {
        let remote: DetailGameDataSource = DetailGameDataSource.shared
        
        return DetailGameRepository.shared(remote: remote)
    }
    
    public func provideDetailGame() -> DetailGameUseCase {
        let repository = provideDetailGameRepository()
        
        return DetailGameInteractor(repository: repository)
    }
}
