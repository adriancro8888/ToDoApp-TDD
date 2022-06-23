//
//  Task.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

struct Task {
    var title: String
    var description: String?
    private(set) var date: Date?
    
    init(title: String, description: String? = nil) {
        self.title = title
        self.description = description
        self.date = Date()
    }
}
