//
//  CoreDataManager+FavoriteGame.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation
import CoreData

extension CoreDataManager: CoreDataFavoriteGameManagerProtocol {
    static func addFavoriteGame(model: AddFavoriteGameModel) {
        let event = FavoriteGames(context: moc)
        event.id = Int64(model.id)
        event.name = model.name
        event.released = model.released
        event.backgroundImage = model.backgroundImage
        event.rating = model.rating
        event.genres = model.genres
        
        save()
    }
    
    static func deleteFavoriteGameById(_ id: Int) {
        let fetchRequest = FavoriteGames.fetchRequest() as NSFetchRequest
        let predicate = NSPredicate(format: "(id = %lld)", id)
        fetchRequest.predicate = predicate
        
        do {
            let results = try moc.fetch(fetchRequest)
            guard let objectUpdate = results.first else { return }
            
            delete(objectUpdate)
        } catch let error {
            print("Delete favorite game with id = \(id) error: ", error)
        }
    }
    
    static func fetchAllFavoriteGame() -> [FavoriteGames] {
        do {
            let fetchRequest = FavoriteGames.fetchRequest() as NSFetchRequest
            let events = try moc.fetch(fetchRequest)
            
            return events
        } catch {
            return []
        }
    }
}
