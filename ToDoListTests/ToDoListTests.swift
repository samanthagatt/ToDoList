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
    
    func testOnAppearLoadsPreviouslyStoredToDos() {
        // Arrange
        let expectedToDos = mockToDoData.prefix(3).map {
            ToDo(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                dateCreated: $0.dateCreated,
                context: cdManager.context
            )
        }
        cdManager.save()
        for expected in expectedToDos {
            XCTAssertFalse(sut.todos.contains(expected))
        }
        XCTAssertEqual(sut.todos.count, 0)
        
        // Act
        sut.onAppear()
        
        // Assert
        XCTAssertEqual(sut.todos.count, expectedToDos.count)
        for expected in expectedToDos {
            let actual = sut.todos.first(where: { $0 == expected })
            XCTAssertNotNil(actual)
        }
    }
    
    func testAddToDoAddsBlankToDo() throws {
        // Arrange
        let earliestDate = Date()
        XCTAssertTrue(sut.todos.isEmpty)
        sut.onAppear()
        
        // Act
        sut.addToDo()
        
        // Assert
        XCTAssertFalse(cdManager.context.hasChanges)
        XCTAssertEqual(sut.todos.count, 1)
        let actual = try XCTUnwrap(sut.todos.first)
        XCTAssertNotNil(actual.id)
        XCTAssertEqual(actual.title, "")
        XCTAssertEqual(actual.isComplete, false)
        let dateCreated = try XCTUnwrap(actual.dateCreated)
        XCTAssertTrue(dateCreated.isBetween(earliestDate, .now))
    }
    
    // Switched from method on the ViewModel in the Binding setter
    // to using the binding provided in the ForEach with a default value
    // so this test's a bit obsolete now but keeping it for reference
    // since underlying functionality is the same
    func testUpdatingTitleWithoutEditingChangeDoesNotSaveToCoreData() {
        // Arrange
        let expectedOldTitle = mockToDoData[0].title
        let todo = ToDo(
            id: mockToDoData[0].id,
            title: expectedOldTitle,
            isComplete: mockToDoData[0].isComplete,
            dateCreated: mockToDoData[0].dateCreated,
            context: cdManager.context
        )
        let expectedNewTitle = "New title"
        cdManager.save()
        
        // Act
        sut.onTitleEditingChanged(isEditing: true)
        todo.title = expectedNewTitle
        
        // Assert
        XCTAssertTrue(cdManager.context.hasChanges)
        XCTAssertEqual(todo.title, expectedNewTitle)
        // Discards pending changes
        cdManager.context.refresh(todo, mergeChanges: false)
        XCTAssertEqual(todo.title, expectedOldTitle)
        sut.onTitleEditingChanged(isEditing: false)
    }
    
    func testOnTitleEditingChangedFalseSavesToCoreData() {
        // Arrange
        let expectedOldTitle = mockToDoData[0].title
        let todo = ToDo(
            id: mockToDoData[0].id,
            title: expectedOldTitle,
            isComplete: mockToDoData[0].isComplete,
            dateCreated: mockToDoData[0].dateCreated,
            context: cdManager.context
        )
        let expectedNewTitle = "New title"
        cdManager.save()
        
        // Act
        sut.onTitleEditingChanged(isEditing: true)
        todo.title = expectedNewTitle
        sut.onTitleEditingChanged(isEditing: false)
        
        // Assert
        XCTAssertFalse(cdManager.context.hasChanges)
        XCTAssertEqual(todo.title, expectedNewTitle)
    }
    
    func testToggleCompleteUpdatesToDoAndSavesToCoreData() {
        // Arrange
        let expectedOldIsComplete = mockToDoData[0].isComplete
        let todo = ToDo(
            id: mockToDoData[0].id,
            title: mockToDoData[0].title,
            isComplete: expectedOldIsComplete,
            dateCreated: mockToDoData[0].dateCreated,
            context: cdManager.context
        )
        
        // Act
        sut.toggleComplete(for: todo)
        
        // Assert
        XCTAssertFalse(cdManager.context.hasChanges)
        XCTAssertEqual(todo.isComplete, !expectedOldIsComplete)
    }
    
    func testOnDeleteDeletesSpecifiedToDosAndSavesToCoreData() {
        // Arrange
        let prefix = 3
        _ = mockToDoData.map {
            ToDo(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                dateCreated: $0.dateCreated,
                context: cdManager.context
            )
        }
        cdManager.save()
        sut.onAppear()
        let allTodos = sut.todos
        for todo in allTodos.prefix(prefix) {
            XCTAssertTrue(sut.todos.contains(todo))
        }
        
        // Act
        sut.onDelete(indices: IndexSet(0..<prefix))
        
        // Assert
        XCTAssertFalse(cdManager.context.hasChanges)
        for todo in allTodos.prefix(prefix) {
            XCTAssertFalse(sut.todos.contains(todo))
        }
        for todo in allTodos.suffix(allTodos.count - 3) {
            XCTAssertTrue(sut.todos.contains(todo))
        }
    }
}
