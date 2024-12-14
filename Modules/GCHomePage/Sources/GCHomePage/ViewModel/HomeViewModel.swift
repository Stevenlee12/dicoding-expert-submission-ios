//
//  HomeViewModel.swift
//  GCHomePage
//
//  Created by Steven Lie on 09/12/24.
//

import Foundation
import Combine

import GCGames
import GCCommon

public final class HomeViewModel: ObservableObject {
    @Published var gameResult: Result<[GameModel]>? = .loading
    
    private var gameModel: [GameModel]?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let trendingGamesUseCase: TrendingGamesUseCase
    
    let gameGenreData = [
        GameGenreModel(id: 1, genre: "Action", image: "action"),
        GameGenreModel(id: 2, genre: "Arcade", image: "arcade"),
        GameGenreModel(id: 3, genre: "Card", image: "cards"),
        GameGenreModel(id: 4, genre: "RPG", image: "rpg"),
        GameGenreModel(id: 5, genre: "Sports", image: "sport")
    ]
    
    public init(trendingGamesUseCase: TrendingGamesUseCase) {
        self.trendingGamesUseCase = trendingGamesUseCase
    }
    
    func getGamesData() {
        gameResult = .loading
        
        trendingGamesUseCase.getTrendingGames()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.gameResult = .failure("Failed to load games: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.gameModel = response
                self?.gameResult = .success(response)
            })
            .store(in: &cancellables)
    }
    
    func getSpecificGame(idx: Int) -> GameModel? {
        return gameModel?[idx]
    }
    
    func getGamesCount() -> Int {
        return gameModel?.count ?? 0
    }
}
