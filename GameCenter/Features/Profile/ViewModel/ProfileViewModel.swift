//
//  ProfileViewModel.swift
//  GameCenter
//
//  Created by Steven Lie on 29/10/24.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var activitiesLog = [ActivitiesLog]()
    
    private var fetchGamesUseCase: FetchGamesUseCaseProtocol
    
    init(fetchGamesUseCase: FetchGamesUseCaseProtocol) {
        self.fetchGamesUseCase = fetchGamesUseCase
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func getActivityLog() {
        activitiesLog = fetchGamesUseCase.retrieveActivityLog()
    }
}
