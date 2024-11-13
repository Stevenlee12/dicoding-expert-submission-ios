//
//  ActivitiesLog+CoreDataProperties.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//
//

import Foundation
import CoreData

extension ActivitiesLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivitiesLog> {
        return NSFetchRequest<ActivitiesLog>(entityName: "ActivitiesLog")
    }

    @NSManaged public var gameImage: String?
    @NSManaged public var activityStatus: Int16
    @NSManaged public var gameTitle: String?
    @NSManaged public var id: Int64
    @NSManaged public var date: Date?

}

extension ActivitiesLog: Identifiable {
}
