//
//  FavoriteGamesViewModel.swift
//  GCFavoriteGamesPage
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation
import Combine

import GCGames

public final class FavoriteGamesViewModel: ObservableObject {
    @Published var favoriteGames = [FavoriteGameModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var favoriteGamesUseCase: FavoriteGamesUseCase
    
    public init(favoriteGamesUseCase: FavoriteGamesUseCase) {
        self.favoriteGamesUseCase = favoriteGamesUseCase
    }
    
    func getFavoriteGames() {
        return favoriteGamesUseCase
            .retrieveFavoriteGames()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                self?.favoriteGames = response
            })
            .store(in: &cancellables)
    }
}
