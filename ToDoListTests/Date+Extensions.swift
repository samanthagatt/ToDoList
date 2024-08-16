//
//  Date+Extensions.swift
//  ToDoListTests
//
//  Created by Samantha Gatt on 8/15/24.
//

import Foundation

extension Date {
    func isBetween(_ lhs: Date, _ rhs: Date) -> Bool {
        DateInterval(start: min(lhs, rhs), end: max(lhs, rhs)).contains(self)
    }
}
