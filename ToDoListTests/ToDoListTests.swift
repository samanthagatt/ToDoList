//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Samantha Gatt on 8/15/24.
//

@testable import ToDoList
import XCTest

final class ToDoListTests: XCTestCase {
    var cdManager: CoreDataManager!
    var sut: ToDoListView.ViewModel!
    let mockToDoData: [(id: UUID, title: String, isComplete: Bool, dateCreated: Date)] = [
        (UUID(), "todo1", false, .now + 1000),
        (UUID(), "todo2", true, .now),
        (UUID(), "todo3", false, .now - 1000),
        (UUID(), "todo4", true, .distantPast),
        (UUID(), "todo5", false, .distantFuture)
    ]
    
    override func setUp() {
        super.setUp()
        cdManager = CoreDataManager(mock: true)
        sut = ToDoListView.ViewModel(cdManager: cdManager)
    }
}
