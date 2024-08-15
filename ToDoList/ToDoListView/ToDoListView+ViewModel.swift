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
        
        var request: NSFetchRequest<ToDo> = {
            let req = ToDo.fetchRequest()
            req.sortDescriptors = [
                NSSortDescriptor(key: "isComplete", ascending: true),
                NSSortDescriptor(key: "dateCreated", ascending: true)
            ]
            return req
        }()
        lazy var fetchController: NSFetchedResultsController = {
            let controller = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: cdManager.context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            controller.delegate = self
            return controller
        }()
        let cdManager: CoreDataManager
        private let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier ?? "ToDoList",
            category: String(reflecting: ViewModel.self)
        )
        
        @Published var todos: [ToDo] = []
        
        init(cdManager: CoreDataManager = .shared) {
            self.cdManager = cdManager
            super.init()
        }
        
        func controllerDidChangeContent(
            _ controller: NSFetchedResultsController<NSFetchRequestResult>
        ) {
            if let new = controller.fetchedObjects as? [ToDo] {
                todos = new
            }
        }
        
        func onAppear() {
            do {
                try fetchController.performFetch()
                todos = fetchController.fetchedObjects ?? []
            } catch {
                logger.error("Error fetching ToDos: \(error)")
            }
        }
        
        func addToDo() {
            _ = ToDo(title: "", context: cdManager.context)
            cdManager.save()
        }
        
        func updateTitle(for todo: ToDo, to newTitle: String) {
            todo.title = newTitle
        }
        
        func onTitleEditingChanged(isEditing: Bool) {
            if !isEditing {
                cdManager.save()
            }
        }
    }
}
