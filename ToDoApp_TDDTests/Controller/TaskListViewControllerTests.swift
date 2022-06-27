//
//  TaskListViewControllerTests.swift
//  ToDoApp_TDDTests
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import XCTest
@testable import ToDoApp_TDD

class TaskListViewControllerTests: XCTestCase {
    
    var sut: TaskListViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: TaskListViewController.self))
        
        sut = viewController as? TaskListViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testWhenViewIsLoadedTableViewNotNill() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func testWhenViewIsLoadedDataProviderIsNotNil() {
        XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSourceEqualsTableViewDelegate() {
        XCTAssertEqual(
            sut.tableView.delegate as? DataProvider,
            sut.tableView.dataSource as? DataProvider
        )
    }
    
    func testTaskListViewControllerHasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewController, sut)
    }
    
    func presentingNewTaskViewController() -> NewTaskViewController {
        guard let newTaskButton = sut.navigationItem.rightBarButtonItem,
              let action = newTaskButton.action else {
            XCTFail()
            return NewTaskViewController()
        }
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)

        
        let newTaskVC = sut.presentedViewController as! NewTaskViewController
        return newTaskVC
    }
    
    func testAddNewTaskPresentsNewTaskViewController() {
        let newtaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(newtaskViewController.dateTextField)
        
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        let newtaskViewController = presentingNewTaskViewController()
        XCTAssertNotNil(sut.dataProvider.taskManager)
        XCTAssertTrue(newtaskViewController.taskManager === sut.dataProvider.taskManager)
        
    }
    
    func testVhenViewAppearedTableViewReloaded() {
        let mockTableView = MockTableView()
        sut.tableView = mockTableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager?.add(task: task)
        
        expectation(forNotification: NSNotification.Name(rawValue: "DidSelectRow Notification"), object: nil) { notification -> Bool in
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else {
                return false
            }
            return task == taskFromNotification
        }
        
        let tableView = sut.tableView
        tableView?.delegate?.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        
        let task = Task(title: "Foo")
        let task1 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task)
        sut.dataProvider.taskManager?.add(task: task1)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidSelectRow Notification"), object: self, userInfo: ["task" : task1])
        
        guard let detailViewController = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailViewController.task == task1)
        
    }
}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
}

extension TaskListViewControllerTests {
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
    }
}
