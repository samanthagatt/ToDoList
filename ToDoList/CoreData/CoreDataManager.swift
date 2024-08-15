//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/14/24.
//

import CoreData
import OSLog

class CoreDataManager {
    // MARK: - Static Instances
    /// Live instance of CoreDataManager
    static let shared = CoreDataManager()
    #if DEBUG
    /// Mock instance of CoreDataManager for ease of use in SwiftUI Previews
    static let previews: CoreDataManager = {
        let controller = CoreDataManager(mock: true)
        let mockToDos = [
            ToDo(title: "Wash dishes", isComplete: true, context: controller.context),
            ToDo(title: "Take out trash", context: controller.context),
            ToDo(title: "Fold laundry", context: controller.context),
        ]
        controller.save()
        return controller
    }()
    #endif
    
    // MARK: - Properties
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ToDoList",
        category: String(reflecting: CoreDataManager.self)
    )
    private let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    // MARK: - Initializers
    init(mock: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList")
        if mock {
            // Use in memory storage
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { [weak self] _, error in
            if let error {
                self?.logger.critical("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Methods
    /// Saves managed object context if there are any pending changes
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                logger.error("Error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}
