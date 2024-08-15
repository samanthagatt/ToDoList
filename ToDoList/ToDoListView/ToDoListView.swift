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
                Text(todo.title ?? "")
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    NavigationStack {
        ToDoListView(viewModel: ToDoListView.ViewModel(cdManager: .mock))
    }
}
