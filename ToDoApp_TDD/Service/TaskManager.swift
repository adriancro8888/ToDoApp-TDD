//
//  TaskManager.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation
import UIKit

class TaskManager {
    
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []
    
    var tasksCount: Int {
        tasks.count
    }
    var doneTasksCount: Int {
        doneTasks.count
    }
    
    var tasksURL: URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else { fatalError() }
        
        return documentURL.appendingPathComponent("tasks.plist")
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let data = try? Data(contentsOf: tasksURL) {
            let dictionaries = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [[String : Any]]
            
            for dictionary in dictionaries ?? [] {
                if let task = Task(dict: dictionary) {
                    tasks.append(task)
                }
            }
        }
    }
    
    deinit {
        save()
    }
    
    func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }
    
    func task(at index: Int) -> Task {
        tasks[index]
    }
    
    func checkTask(at index: Int) {
        let task = tasks.remove(at: 0)
        doneTasks.append(task)
    }
    
    func uncheckTask(at index: Int) {
        let task = doneTasks.remove(at: 0)
        tasks.append(task)
    }
    
    func doneTask(at index: Int) -> Task {
        doneTasks[index]
    }
    
    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
    
    @objc func save() {
        let taskDictionaries = self.tasks.map { $0.dictionary
        }
        
        guard taskDictionaries.count > 0 else {
            try? FileManager.default.removeItem(at: tasksURL)
            return
        }
        
        let plistData = try? PropertyListSerialization.data(
            fromPropertyList: taskDictionaries,
            format: .xml,
            options: PropertyListSerialization.WriteOptions(0)
        )
        
        try? plistData?.write(to: tasksURL, options: .atomic)
    }
}
