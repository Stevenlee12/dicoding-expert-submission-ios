//
//  GameDetailViewModel.swift
//  GameCenter
//
//  Created by Steven Lie on 29/10/24.
//

import Foundation
import Alamofire
import Combine

final class GameDetailViewModel: ObservableObject {
    @Published var detailGameResult: Result<DetailGameModel>? = .loading
    private var detailGame: DetailGameModel?

    private var cancellables = Set<AnyCancellable>()
    
    private var fetchGamesUseCase: FetchGamesUseCaseProtocol
    
    init(fetchGamesUseCase: FetchGamesUseCaseProtocol) {
        self.fetchGamesUseCase = fetchGamesUseCase
    }
    
    func getGameDetail(gameId: Int) {
        detailGameResult = .loading
        
        fetchGamesUseCase
            .executeFetchGameDetail(byID: gameId)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.detailGameResult = .failure("Failed to load games: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] response in
                self?.detailGame = response
                self?.detailGameResult = .success(response)
            })
            .store(in: &cancellables)
    }
    
    func addActivityLog(activityStatus: Int) {
        guard let data = detailGame else { return }
        
        let logModel = AddActivityLogModel(
            id: UUID().uuidString.hash,
            gameImage: data.backgroundImage ?? "",
            activityStatus: activityStatus,
            gameTitle: data.name ?? "",
            date: Date()
        )
        
        fetchGamesUseCase.executeAddActivityLog(logModel)
    }
    
    func addFavoriteGame() {
        guard let data = detailGame else { return }
        
        let genres = data.genres ?? [Genre]()
        let gameGenres = genres.map({ $0.name ?? "" }).joined(separator: ", ")
        
        let model = AddFavoriteGameModel(
            id: data.id,
            name: data.name ?? "",
            released: data.released ?? "",
            backgroundImage: data.backgroundImage ?? "",
            rating: data.rating ?? 0.0,
            genres: gameGenres
        )
        
        fetchGamesUseCase.executeAddGameToFavorites(model)
    }
    
    func deleteFavoriteGameById() {
        guard let detailGame else { return }
        
        fetchGamesUseCase.executeRemoveFavoriteGame(byID: detailGame.id)
    }
}
