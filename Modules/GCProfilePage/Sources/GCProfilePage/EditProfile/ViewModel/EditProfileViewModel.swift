//
//  File.swift
//  GCProfilePage
//
//  Created by Steven Lie on 13/12/24.
//

import Foundation
import Combine

import GCProfile

public final class EditProfileViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    
    private var profileUseCase: ProfileUseCase
    
    public init(profileUseCase: ProfileUseCase) {
        self.profileUseCase = profileUseCase
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func getUserData() {
        let userData = profileUseCase.getUserData()
        name = userData.name
        email = userData.email
    }
    
    func updateUserData(user: User) {
        return profileUseCase.updateUserData(user: user)
    }
}
