//
//  LocationTests.swift
//  ToDoApp_TDDTests
//
//  Created by Felix Titov on 6/23/22.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import XCTest
import CoreLocation
@testable import ToDoApp_TDD

class LocationTests: XCTestCase {
    
    override class func setUp() {
        
    }

    override func tearDown() {
        
    }
    
    func testInitSetsName() {
        let location = Location(name: "Foo")
        
        XCTAssertEqual(location.name, "Foo")
    }
    
    func testInitSetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        let location = Location(name: "Foo", coordinate: coordinate)
        
        XCTAssertEqual(coordinate.latitude, location.coordinate?.latitude)
        
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }

}
