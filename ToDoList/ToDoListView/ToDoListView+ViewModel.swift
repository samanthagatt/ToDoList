//
//  ToDoListView+ViewModel.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/14/24.
//

import CoreData
import OSLog

extension ToDoListView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        // MARK: - Private Properties
        /// Fetch request for all ToDos
        ///
        /// Sorted by dateCreated (newer to older) with incomplete ToDos at the top
        private var request: NSFetchRequest<ToDo> = {
            let req = ToDo.fetchRequest()
            req.sortDescriptors = [
                NSSortDescriptor(key: "isComplete", ascending: true),
                NSSortDescriptor(key: "dateCreated", ascending: true)
            ]
            return req
        }()
        /// Fetched results controller for all ToDos
        private lazy var fetchController: NSFetchedResultsController = {
            let controller = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: cdManager.context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            controller.delegate = self
            return controller
        }()
        private let cdManager: CoreDataManager
        private let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "ToDoList",
            category: String(reflecting: ViewModel.self)
        )
        // MARK: - Published Properties
        @Published var todos: [ToDo] = []
        
        // MARK: - Initializers
        init(cdManager: CoreDataManager = .shared) {
            self.cdManager = cdManager
            super.init()
        }
        
        // MARK: - NSFetchedResultsControllerDelegate implementation
        // Makes sure published `todos` variable is updated when the fetch results change
        func controllerDidChangeContent(
            _ controller: NSFetchedResultsController<NSFetchRequestResult>
        ) {
            if let new = controller.fetchedObjects as? [ToDo] {
                todos = new
            }
        }
        
        // MARK: - View Life Cycle
        /// onAppear for ToDoListView
        ///
        /// Performs fetch request for all ToDos
        func onAppear() {
            do {
                try fetchController.performFetch()
                todos = fetchController.fetchedObjects ?? []
            } catch {
                logger.error("Error fetching ToDos: \(error)")
            }
        }
        
        // MARK: - CRUD
        /// Adds a new blank ToDo
        func addToDo() {
            _ = ToDo(title: "", context: cdManager.context)
            cdManager.save()
        }
        
        /// Updates the title for the specified ToDo
        func updateTitle(for todo: ToDo, to newTitle: String) {
            todo.title = newTitle
        }
        
        /// onEditingChanged for ToDo title TextField
        ///
        /// Makes sure the changes are saved in CoreData when the user ends editing
        func onTitleEditingChanged(isEditing: Bool) {
            if !isEditing {
                cdManager.save()
            }
        }
        
        /// Toggles completion status and saves changes to CoreData
        func toggleComplete(for todo: ToDo) {
            todo.isComplete.toggle()
            cdManager.save()
        }
        
        /// onDelete for ToDo List cells
        ///
        /// Deletes the selected ToDo(s) and saves changes to CoreData
        func onDelete(indices: IndexSet) {
            for index in indices {
                cdManager.context.delete(todos[index])
            }
            cdManager.save()
        }
    }
}
