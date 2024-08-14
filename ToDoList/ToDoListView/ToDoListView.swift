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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        ToDoListView()
    }
}
