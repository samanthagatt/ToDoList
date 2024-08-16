//
//  Binding+Extensions.swift
//  ToDoList
//
//  Created by Samantha Gatt on 8/15/24.
//

import SwiftUI

extension Binding {
    func with<T>(default defaultValue: T) -> Binding<T> where T? == Value {
        Binding<T>(
            get: { wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
