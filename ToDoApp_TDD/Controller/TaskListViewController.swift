//
//  ViewController.swift
//  ToDoApp_TDD
//
//  Created by Felix Titov on 6/22/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class TaskListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetail(withNotification:)), name: NSNotification.Name(rawValue: "DidSelectRow Notification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func showDetail(withNotification notification: Notification) {
        guard let userInfo = notification.userInfo,
              let task = userInfo["task"] as? Task,
        let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            fatalError()
        }
        
        detailVC.task = task
        navigationController?.pushViewController(detailVC, animated: true)
        

    }

    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            viewController.taskManager = self.dataProvider.taskManager
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
        
    }
    
}

