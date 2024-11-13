//
//  FavoriteGames+CoreDataProperties.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//
//

import Foundation
import CoreData

extension FavoriteGames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteGames> {
        return NSFetchRequest<FavoriteGames>(entityName: "FavoriteGames")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var released: String?
    @NSManaged public var backgroundImage: String?
    @NSManaged public var rating: Double
    @NSManaged public var genres: String?

}

extension FavoriteGames: Identifiable {
}
