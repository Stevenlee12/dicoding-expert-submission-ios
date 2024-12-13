//
//  DI.swift
//  GameCenter
//
//  Created by Steven Lie on 12/12/24.
//

import GCGames
import GCDetailGame
import GCProfile
import GCHomePage
import GCSearchPage
import GCFavoriteGamesPage
import GCProfilePage

final class Injection {
    static let shared = Injection()
    
    private let gameInjection = GameInjection()
    private let detailGameInjection = DetailGameInjection()
    private let profileInjection = ProfileInjection()
    
    func provideTrendingGames() -> TrendingGamesUseCase {
        return gameInjection.provideTrendingGames()
    }
    
    func provideSearchGames() -> SearchGamesUseCase {
        return gameInjection.provideSearchGames()
    }
    
    func provideDetailGame() -> DetailGameUseCase {
        return detailGameInjection.provideDetailGame()
    }
    
    func provideFavoriteGames() -> FavoriteGamesUseCase {
        return gameInjection.provideFavoriteGames()
    }
    
    func provideActivitiesLog() -> ProfileUseCase {
        return profileInjection.provideActivitiesLog()
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(trendingGamesUseCase: provideTrendingGames())
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(searchGamesUseCase: provideSearchGames())
    }
    
    func makeFavoriteGamesViewModel() -> FavoriteGamesViewModel {
        return FavoriteGamesViewModel(favoriteGamesUseCase: provideFavoriteGames())
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(profileUseCase: provideActivitiesLog())
    }
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel())
    }
    
    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchViewModel())
    }
    
    func makeFavoriteGamesViewController() -> FavoriteGamesViewController {
        return FavoriteGamesViewController(viewModel: makeFavoriteGamesViewModel())
    }
    
    func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController(viewModel: makeProfileViewModel())
    }
}
