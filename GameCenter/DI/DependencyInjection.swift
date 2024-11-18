//
//  DependencyInjection.swift
//  GameCenter
//
//  Created by Steven Lie on 01/11/24.
//

import Swinject

class DependencyInjection {
    static var shared = DependencyInjection()
    let container: Container

    private init() {
        container = Container()
        setupDependencies()
    }

    public static func reset() {
        shared = DependencyInjection() // Reset to a new instance to clear registrations
    }

    private func setupDependencies() {
        container.register(NetworkManagerProtocol.self) { _ in
            NetworkManager()
        }

        container.register(GameRepositoryProtocol.self) { resolver in
            let networkManager = resolver.resolve(NetworkManagerProtocol.self)!
            return GameRepository(networkManager: networkManager) // Inject the NetworkManager
        }
        
        container.register(FetchGamesUseCaseProtocol.self) { resolver in
            let repository = resolver.resolve(GameRepositoryProtocol.self)!
            return FetchGamesUseCase(repository: repository) // Inject the GameRepository
        }
        
        container.register(HomeViewModel.self) { resolver in
            let fetchGamesUseCase = resolver.resolve(FetchGamesUseCaseProtocol.self)!
            return HomeViewModel(fetchGamesUseCase: fetchGamesUseCase) // Inject the FetchGamesUseCase
        }
        
        container.register(SearchViewModel.self) { resolver in
            let fetchGamesUseCase = resolver.resolve(FetchGamesUseCaseProtocol.self)!
            return SearchViewModel(fetchGamesUseCase: fetchGamesUseCase) // Inject the FetchGamesUseCase
        }
        
        container.register(ProfileViewModel.self) { resolver in
            let fetchGamesUseCase = resolver.resolve(FetchGamesUseCaseProtocol.self)!
            return ProfileViewModel(fetchGamesUseCase: fetchGamesUseCase) // Inject the FetchGamesUseCase
        }
        
        container.register(FavoriteViewModel.self) { resolver in
            let fetchGamesUseCase = resolver.resolve(FetchGamesUseCaseProtocol.self)!
            return FavoriteViewModel(fetchGamesUseCase: fetchGamesUseCase) // Inject the FetchGamesUseCase
        }
        
        container.register(GameDetailViewModel.self) { resolver in
            let fetchGamesUseCase = resolver.resolve(FetchGamesUseCaseProtocol.self)!
            return GameDetailViewModel(fetchGamesUseCase: fetchGamesUseCase) // Inject the FetchGamesUseCase
        }
    }
}

