//
//  ProfileViewModel.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import Foundation
import Combine

import GCProfile

public final class ProfileViewModel: ObservableObject {
    @Published var activitiesLog = [ActivityLogModel]()
    @Published var name = ""
    @Published var email = ""
    
    private var profileUseCase: ProfileUseCase
    
    public init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func getActivityLog() {
        return profileUseCase
            .retrieveActivitiesLog()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { [weak self] response in
                self?.activitiesLog = response
            })
            .store(in: &cancellables)
    }
    
    func getUserData() {
        let userData = profileUseCase.getUserData()
        name = userData.name
        email = userData.email
    }
}
