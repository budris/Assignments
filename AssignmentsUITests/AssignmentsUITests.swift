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
        
        continueAfterFailure = false
        
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreationTask() {
        app.tabBars.buttons["Tasks"].tap()
        
        let cellCountBeforeCreate = app.tables.element(boundBy: 0).cells.count
        
        app.navigationBars["Tasks"].buttons["Add"].tap()
        
        // Test alert
        app.navigationBars["New Task"].buttons["Create"].tap()
        app.alerts["Error"].buttons["Ok"].tap()
        
        let taskTitleTextField = app.textFields["TaskTitle"]
        taskTitleTextField.tap()
        taskTitleTextField.typeText("test task title")
        
        let contentTextView = app.textViews["ContentTextView"]
        contentTextView.tap()
        contentTextView.typeText("Task content test")
        
        let tablesQuery = app.tables
        let startDateCell = tablesQuery.cells.containing(.staticText, identifier:"Start Date").element
        startDateCell.tap()
        
        let toolbarsQuery = app.toolbars
        toolbarsQuery.buttons["Done"].tap()
        
        let durationCell = tablesQuery.cells.containing(.staticText, identifier:"Duration In Minutes").element
        durationCell.tap()
        
        toolbarsQuery.buttons["Done"].tap()
        
        tablesQuery.staticTexts["medium"].tap()
        tablesQuery.staticTexts["high"].tap()
        app.navigationBars["Priority"].buttons["New Task"].tap()
        
        app.navigationBars["New Task"].buttons["Create"].tap()
        
        let cellCountAfterCreate = app.tables.element(boundBy: 0).cells.count
        let shouldBeAfterCreationCellCount = cellCountAfterCreate - 1
        
        XCTAssertEqual(cellCountBeforeCreate, shouldBeAfterCreationCellCount)
    }
    
}
