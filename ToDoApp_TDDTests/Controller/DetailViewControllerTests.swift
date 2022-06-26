//
//  DetailViewControllerTests.swift
//  ToDoApp_TDDTests
//
//  Created by Felix Titov on 6/26/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import XCTest
@testable import ToDoApp_TDD
import CoreLocation

class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func setUpTasKAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 54.74801923, longitude: 56.01103876)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1546300800)
        let task = Task(title: "Foo", description: "Bar", location: location, date: date )
        
        sut.task = task
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    
    func testHasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
        
    }
    
    func testHasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func testHasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    
    func testHasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }
    
    
    func testSettingTaskSetsTitleLabel() {
        setUpTasKAndAppearanceTransition()
        XCTAssertEqual(sut.titleLabel.text, "Foo")
        
    }
    
    func testSettingTaskSetsDescriptionLabel() {
        setUpTasKAndAppearanceTransition()
        XCTAssertEqual(sut.descriptionLabel.text, "Bar")
        
    }
    
    func testSettingTaskSetsLocationLabel() {
        setUpTasKAndAppearanceTransition()
        XCTAssertEqual(sut.locationLabel.text, "Baz")
        
    }
}
