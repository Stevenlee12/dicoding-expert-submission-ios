//
//  SearchViewModel.swift
//  GameCenter
//
//  Created by Steven Lie on 10/09/24.
//

import Foundation
import Combine
import Alamofire

final class SearchViewModel: ObservableObject {
    @Published var gameResult: Result<[GameModel]>?
    fileprivate var games: [GameModel]?

    private var cancellables = Set<AnyCancellable>()
    
    private var fetchGamesUseCase: FetchGamesUseCaseProtocol
    
    init(fetchGamesUseCase: FetchGamesUseCaseProtocol) {
        self.fetchGamesUseCase = fetchGamesUseCase
    }
    
    func searchGame(query: String?) {
        gameResult = .loading

        fetchGamesUseCase
            .executeFetchGames(matching: query)
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
                if response.results?.isEmpty ?? true {
                    self?.gameResult = .failure("No games found.")
                } else {
                    self?.games = response.results
                    self?.gameResult = .success(response.results)
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
