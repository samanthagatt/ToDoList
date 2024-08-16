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
                    Image(systemName: todo.isComplete ? "largecircle.fill.circle" : "circle")
                        .onTapGesture {
                            viewModel.toggleComplete(for: todo)
                        }
                        .foregroundColor(.brown)
                    TextField(
                        "Title",
                        text: $todo.title.with(default: ""),
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
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
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

#if DEBUG
#Preview {
    NavigationStack {
        ToDoListView(viewModel: ToDoListView.ViewModel(cdManager: .previews))
    }
}
#endif
