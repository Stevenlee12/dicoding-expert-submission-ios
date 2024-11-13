//
//  CoreDataManager+Utility.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation
import CoreData

extension CoreDataManager: CoreDataUtilityManagerProtocol {
    static func isFavoriteGameExist(_ gameId: Int) -> Bool {
        do {
            let fetchRequest = FavoriteGames.fetchRequest() as NSFetchRequest
            let predicate = NSPredicate(format: "(id = %lld)", Int64(gameId))
            fetchRequest.predicate = predicate
            
            return ((try moc.fetch(fetchRequest).first) != nil)
        } catch {
            return false
        }
    }
}
