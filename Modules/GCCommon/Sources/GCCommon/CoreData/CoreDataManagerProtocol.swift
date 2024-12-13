//
//  CoreDataManagerProtocol.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation
import CoreData

@MainActor
protocol CoreDataManagerProtocol {
    // MARK: BASIC
    func save()
    func delete(_ item: NSManagedObject)
    
    // MARK: - GENERAL
    func clearAllCoreData()
    func clearDeepObjectEntity(_ entity: String)
}

protocol CoreDataFavoriteGameManagerProtocol: CoreDataManagerProtocol {
    func addFavoriteGame(model: AddFavoriteGameModel)
    func deleteFavoriteGameById(_ id: Int)
    
    func fetchAllFavoriteGame() -> [FavoriteGames]
}

protocol CoreDataUtilityManagerProtocol: CoreDataManagerProtocol {
    func isFavoriteGameExist(_ gameId: Int) -> Bool
}

protocol CoreDataActivityLogManagerProtocol: CoreDataManagerProtocol {
    func addActivityLog(model: AddActivityLogModel)
    
    func fetchAllActivityLog() -> [ActivitiesLog]
}
