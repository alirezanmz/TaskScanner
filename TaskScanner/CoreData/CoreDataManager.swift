//
//  CoreDataManager.swift
//  TaskScanner
//
//  Created by Alireza Namazi on 8/8/24.
//

import CoreData

// Singleton class to manage Core Data operations.
class CoreDataManager {
    static let shared = CoreDataManager()  // Shared instance for global access.
    
    private let persistentContainer: NSPersistentContainer  // Core Data stack container.
    
    // Initializes the Core Data stack and loads the persistent store.
    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskScanner")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to initialize Core Data stack: \(error)")
            }
        }
    }
    
    // Returns the main context associated with the persistent container.
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Saves changes in the context to the persistent store.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
