//
//  FavoriteViewModel.swift
//  GameCenter
//
//  Created by Steven Lie on 29/10/24.
//

import Foundation
import Combine

final class FavoriteViewModel: ObservableObject {
    @Published var favoriteGames = [FavoriteGames]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var fetchGamesUseCase: FetchGamesUseCaseProtocol
    
    init(fetchGamesUseCase: FetchGamesUseCaseProtocol) {
        self.fetchGamesUseCase = fetchGamesUseCase
    }
    
    func getFavoriteGames() {
        favoriteGames = fetchGamesUseCase.retrieveFavoriteGames()
    }
}
