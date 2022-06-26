//
//  Task.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct Task {
    let title: String
    let description: String?
    let location: Location?
    let date: Date?
    
    
    init(title: String, description: String? = nil, location: Location? = nil, date: Date? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.date = date ?? Date()
    }
}

extension Task: Equatable {
    static func == (lhs: Task, rhs: Task) -> Bool {
        if lhs.title == rhs.title, lhs.description == rhs.description, lhs.location == rhs.location {
            return true
        }
        return false
    }
}
