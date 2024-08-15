//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/14/24.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        List {
            ForEach($viewModel.todos) { $todo in
                HStack {
                    Button {
                        viewModel.toggleComplete(for: todo)
                    } label: {
                        Image(systemName: todo.isComplete ? "largecircle.fill.circle" : "circle")
                    }
                    .tint(.brown)
                    TextField(
                        "Title",
                        text: Binding {
                            todo.title ?? ""
                        } set: {
                            viewModel.updateTitle(for: todo, to: $0)
                        },
                        onEditingChanged: viewModel.onTitleEditingChanged
                    )
                    .submitLabel(.done)
                }
            }
            .onDelete(perform: viewModel.onDelete(indices:))
        }
        .onAppear(perform: viewModel.onAppear)
        .navigationTitle("To Do List")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.addToDo()
                } label: {
                    Label("Add ToDo", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ToDoListView(viewModel: ToDoListView.ViewModel(cdManager: .mock))
    }
}
