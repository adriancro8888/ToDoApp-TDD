//
//  TaskManager.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import Foundation

class TaskManager {
    
    var tasksCount: Int {
        tasks.count
    }
    var doneTasksCount: Int {
        doneTasks.count
    }
    
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []
    
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
}
