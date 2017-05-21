//
//  AssignmentsUITests.swift
//  AssignmentsUITests
//
//  Created by Sak, Andrey2 on 5/19/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import XCTest

class AssignmentsUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        app.launchArguments = ["UITesting"]
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        app.tabBars.buttons["Tasks"].tap()
        app.navigationBars["Tasks"].buttons["Add"].tap()

        
    }
    
}
