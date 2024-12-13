//
//  CoreDataManager+FavoriteGame.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation
import CoreData

extension CoreDataManager: CoreDataFavoriteGameManagerProtocol {
    public func addFavoriteGame(model: AddFavoriteGameModel) {
        let event = FavoriteGames(context: CoreDataManager.shared.mainContext)
        event.id = Int64(model.id)
        event.name = model.name
        event.released = model.released
        event.backgroundImage = model.backgroundImage
        event.rating = model.rating
        event.genres = model.genres
        
        save()
    }
    
    public func deleteFavoriteGameById(_ id: Int) {
        let fetchRequest = FavoriteGames.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "(id = %lld)", id)
        fetchRequest.predicate = predicate
        
        do {
            let results = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            guard let objectUpdate = results.first else { return }
            
            delete(objectUpdate)
        } catch let error {
            print("Delete favorite game with id = \(id) error: ", error)
        }
    }
    
    public func fetchAllFavoriteGame() -> [FavoriteGames] {
        do {
            let fetchRequest = FavoriteGames.fetchRequest() as NSFetchRequest
            let events = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            
            return events
        } catch {
            return []
        }
    }
}
