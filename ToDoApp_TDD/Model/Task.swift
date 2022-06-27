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
    let date: Date
    
    var dictionary: [String : Any] {
        var dict: [String : Any] = [:]
        dict["title"] = title
        dict["description"] = description
        dict["date"] = date
        if let location = location {
            dict["location"] = location.dictionary
        }
        return dict
    }
    
    init(title: String, description: String? = nil, location: Location? = nil, date: Date? = nil) {
        self.title = title
        self.description = description
        self.location = location
        self.date = date ?? Date()
    }
}

extension Task {
    typealias PlistDictionary = [String: Any]
    init?(dict: PlistDictionary) {
        self.title = dict["title"] as! String
        self.description = dict["description"] as? String
        self.date = dict["date"] as? Date ?? Date()
       // self.location = dict["location"] as? Location
        if let locationDict = dict["location"] as? [String : Any] {
            self.location = Location(dict: locationDict)
        } else {
            self.location = nil
        }
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
