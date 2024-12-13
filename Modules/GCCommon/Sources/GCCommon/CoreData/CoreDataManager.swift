//
//  CoreDataManager.swift
//  GameCenter
//
//  Created by Steven Lie on 21/09/22.
//

import UIKit
import CoreData

@MainActor
public final class CoreDataManager: CoreDataManagerProtocol {
    // Singleton instance
    public static let shared = CoreDataManager()

    // Private initializer to enforce singleton usage
    private init() {}

    // MARK: - Core Data Stack
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.module.url(forResource: "GameCenter", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    private lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let persistentStoreURL = applicationDocumentsDirectory.appendingPathComponent("GameCenter.sqlite")

        do {
            let options: [AnyHashable: Any] = [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: options)
        } catch {
            fatalError("Persistent Store error: \(error)")
        }

        return coordinator
    }()

    // Create a new managed object context for each thread/task
    public func createContext(concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: concurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }

    // Shared main context for UI tasks
    public lazy var mainContext: NSManagedObjectContext = {
        return createContext(concurrencyType: .mainQueueConcurrencyType)
    }()

    // MARK: - Core Data Operations
    public func save() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    public func delete(_ item: NSManagedObject) {
        mainContext.delete(item)
        save()
    }

    public func clearAllCoreData() {
        let entities = persistentStoreCoordinator.managedObjectModel.entities
        entities.compactMap { $0.name }.forEach { entityName in
            try? clearDeepObjectEntity(entityName)
        }
    }

    public func clearDeepObjectEntity(_ entity: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try mainContext.execute(deleteRequest)
            save()
        } catch {
            print("Error clearing entity \(entity): \(error)")
        }
    }
}
