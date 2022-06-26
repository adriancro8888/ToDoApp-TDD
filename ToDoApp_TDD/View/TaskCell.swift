//
//  TaskCell.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(withTask task: Task) {
        self.titleLabel.text = task.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        if let date = task.date {
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = dateString
            
        }
        
    }
}
