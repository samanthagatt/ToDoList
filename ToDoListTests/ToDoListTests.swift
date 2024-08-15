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
}

extension Date {
    func isBetween(_ lhs: Date, _ rhs: Date) -> Bool {
        DateInterval(start: min(lhs, rhs), end: max(lhs, rhs)).contains(self)
    }
}
