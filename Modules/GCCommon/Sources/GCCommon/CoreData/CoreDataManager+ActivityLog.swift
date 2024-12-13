//
//  CoreDataManager+ActivityLog.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import Foundation
import CoreData

extension CoreDataManager: CoreDataActivityLogManagerProtocol {
    public func addActivityLog(model: AddActivityLogModel) {
        let event = ActivitiesLog(context: CoreDataManager.shared.mainContext)
        
        event.id = Int64(model.id)
        event.gameImage = model.gameImage
        event.activityStatus = Int16(model.activityStatus)
        event.gameTitle = model.gameTitle
        event.date = model.date
        
        save()
    }
    
    public func fetchAllActivityLog() -> [ActivitiesLog] {
        do {
            let fetchRequest = ActivitiesLog.fetchRequest() as NSFetchRequest
            let dateSort = NSSortDescriptor(key: "date", ascending: false)
            fetchRequest.sortDescriptors = [dateSort]
            
            let events = try CoreDataManager.shared.mainContext.fetch(fetchRequest)
            
            return events
        } catch {
            return []
        }
    }
}
