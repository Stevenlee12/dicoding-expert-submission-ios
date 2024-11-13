//
//  HomeViewModel.swift
//  GameCenter
//
//  Created by Steven Lie on 29/10/24.
//

import Foundation
import Combine
import Alamofire

final class HomeViewModel: ObservableObject {
    @Published var gameResult: Result<Games>? = .loading
    
    private var gameModel: Games?
    
    private var cancellables = Set<AnyCancellable>()
    private var fetchGamesUseCase: FetchGamesUseCaseProtocol
    
    let gameGenreData = [
        GameGenreModel(id: 1, genre: "Action", image: "action"),
        GameGenreModel(id: 2, genre: "Arcade", image: "arcade"),
        GameGenreModel(id: 3, genre: "Card", image: "cards"),
        GameGenreModel(id: 4, genre: "RPG", image: "rpg"),
        GameGenreModel(id: 5, genre: "Sports", image: "sport")
    ]
    
    init(fetchGamesUseCase: FetchGamesUseCaseProtocol) {
        self.fetchGamesUseCase = fetchGamesUseCase
    }
    
    func getGamesData() {
        gameResult = .loading
        
        fetchGamesUseCase
            .executeFetchGames(matching: nil)
            .subscribe(on: DispatchQueue.global(qos: .background))
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
        return gameModel?.results?[idx]
    }
    
    func getGamesCount() -> Int {
        return gameModel?.results?.count ?? 0
    }
}
