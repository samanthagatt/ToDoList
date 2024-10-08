//
//  ToDo+Convenience.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/14/24.
//

import CoreData
import Foundation

extension ToDo {
    convenience init(
        id: UUID = UUID(),
        title: String,
        isComplete: Bool = false,
        dateCreated: Date = .now,
        context: NSManagedObjectContext
    ) {
        self.init(
            entity: NSEntityDescription.entity(
                forEntityName: String(describing: type(of: self)),
                in: context
            ) ?? NSEntityDescription(),
            insertInto: context
        )
        self.id = id
        self.title = title
        self.isComplete = isComplete
        self.dateCreated = dateCreated
    }
}
