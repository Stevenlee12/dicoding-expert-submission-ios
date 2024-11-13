//
//  CoreDataManagerProtocol.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    // MARK: BASIC
    static func save()
    static func delete(_ item: NSManagedObject)
    
    // MARK: - GENERAL
    static func clearAllCoreData()
    static func clearDeepObjectEntity(_ entity: String)
}

protocol CoreDataFavoriteGameManagerProtocol: CoreDataManagerProtocol {
    static func addFavoriteGame(model: AddFavoriteGameModel)
    static func deleteFavoriteGameById(_ id: Int)
    
    static func fetchAllFavoriteGame() -> [FavoriteGames]
}

protocol CoreDataUtilityManagerProtocol: CoreDataManagerProtocol {
    static func isFavoriteGameExist(_ gameId: Int) -> Bool
}

protocol CoreDataActivityLogManagerProtocol: CoreDataManagerProtocol {
    static func addActivityLog(model: AddActivityLogModel)
    
    static func fetchAllActivityLog() -> [ActivitiesLog]
}
