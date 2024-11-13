//
//  CoreDataManager.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import UIKit
import CoreData

final class CoreDataManager: CoreDataManagerProtocol {
    
    static private let managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "GameCenter", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    static private let applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    static private let persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let persistenStoreURL = applicationDocumentsDirectory.appendingPathComponent("GameCenter.sqlite")
        
        do {
            let options: [AnyHashable: Any] = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistenStoreURL, options: options)
        } catch {
            fatalError("Persistent Store error: \(error)")
        }
        
        return coordinator
    }()
    
    static internal let moc: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    static func save() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print(error)
            }
        }
    }
    
    static func delete(_ item: NSManagedObject) {
        moc.delete(item)
        save()
    }
    
    static func clearAllCoreData() {
        let entities = persistentStoreCoordinator.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }
    
    static func clearDeepObjectEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try moc.execute(deleteRequest)
            try moc.save()
        } catch {
            debugPrint("There was an error")
        }
    }
}
