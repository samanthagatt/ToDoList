//
//  ToDoListView+ViewModel.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/14/24.
//

import Foundation

extension ToDoListView {
    class ViewModel: ObservableObject {
        @Published var todos: [ToDo] = []
    }
}
