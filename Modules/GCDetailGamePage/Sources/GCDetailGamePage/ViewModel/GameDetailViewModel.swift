//
//  GameDetailViewModel.swift
//  GCDetailGame
//
//  Created by Steven Lie on 11/12/24.
//

import Foundation
import Alamofire
import Combine

import GCCommon
import GCDetailGame

public final class GameDetailViewModel: ObservableObject {
    @Published var detailGameResult: Result<DetailGameModel>? = .loading
    private var detailGame: DetailGameModel?

    private var cancellables = Set<AnyCancellable>()
    
    private var detailGameUseCase: DetailGameUseCase
    
    public init(detailGameUseCase: DetailGameUseCase) {
        self.detailGameUseCase = detailGameUseCase
    }
    
    func getGameDetail(gameId: Int) {
        detailGameResult = .loading
        
        detailGameUseCase
            .getGameDetail(gameId: gameId)
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
        
        detailGameUseCase.executeAddActivityLog(logModel)
    }
    
    func addFavoriteGame() {
        guard let data = detailGame else { return }
        
        let genres = data.genres ?? [GenreModel]()
        let gameGenres = genres.map({ $0.name ?? "" }).joined(separator: ", ")
        
        let model = AddFavoriteGameModel(
            id: data.id,
            name: data.name ?? "",
            released: data.released ?? "",
            backgroundImage: data.backgroundImage ?? "",
            rating: data.rating ?? 0.0,
            genres: gameGenres
        )
        
        detailGameUseCase.executeAddGameToFavorites(model)
    }
    
    func deleteFavoriteGameById() {
        guard let detailGame else { return }
        
        detailGameUseCase.executeRemoveFavoriteGame(byID: detailGame.id)
    }
    
    func checkFavoriteGameIsFavorited() -> Bool {
        guard let detailGame else { return false }
        
        return detailGameUseCase.isFavoriteGameExist(id: detailGame.id)
    }
}
