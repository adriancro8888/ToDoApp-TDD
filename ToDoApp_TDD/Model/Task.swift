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
    private(set) var date: Date?
    
    
    init(title: String, description: String? = nil, location: Location? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.date = Date()
    }
}
