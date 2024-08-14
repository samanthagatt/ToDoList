//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/14/24.
//

import CoreData
import OSLog

class CoreDataManager {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ToDoList",
        category: String(describing: CoreDataManager.self)
    )
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    init(mock: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList")
        if mock {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { [weak self] _, error in
            if let error {
                self?.logger.critical("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
