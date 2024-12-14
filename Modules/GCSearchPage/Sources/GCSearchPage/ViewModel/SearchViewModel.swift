//
//  SearchViewModel.swift
//  GCSearchPage
//
//  Created by Steven Lie on 12/12/24.
//

import Foundation
import Combine
import Alamofire

import GCCommon
import GCGames

public final class SearchViewModel: ObservableObject {
    @Published var gameResult: Result<[GameModel]>?
    fileprivate var games: [GameModel]?

    private var cancellables = Set<AnyCancellable>()
    
    private var searchGamesUseCase: SearchGamesUseCase
    
    public init(searchGamesUseCase: SearchGamesUseCase) {
        self.searchGamesUseCase = searchGamesUseCase
    }
    
    func searchGame(query: String?) {
        gameResult = .loading

        searchGamesUseCase
            .getGames(matching: query)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.gameResult = .failure("Failed to load games: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                if response.isEmpty {
                    self?.gameResult = .failure("No games found.")
                } else {
                    self?.games = response
                    self?.gameResult = .success(response)
                }
            })
            .store(in: &cancellables)
    }
    
    func getSpecificGame(idx: Int) -> GameModel? {
        return games?[idx]
    }
    
    func getGamesCount() -> Int {
        return games?.count ?? 0
    }
    
    func resetData() {
        games = []
    }
}
