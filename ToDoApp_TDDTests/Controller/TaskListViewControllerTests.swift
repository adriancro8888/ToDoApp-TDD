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
}

extension TaskListViewControllerTests {
    class MockTableView: UITableView {
        var isReloaded = false
        
        override func reloadData() {
            isReloaded = true
        }
    }
}
