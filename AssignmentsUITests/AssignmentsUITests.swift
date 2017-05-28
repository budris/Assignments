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
        super.tearDown()
    }
    
    func testUseCases() {
        testCreationTask()
        testEditionTask()
        testDeletionTask()
    }
    
    func testCreationTask() {
        app.tabBars.buttons["Tasks"].tap()
        
        let cellCountBeforeCreate = app.tables.element(boundBy: 0).cells.count
        
        app.navigationBars["Tasks"].buttons["Add"].tap()
        
        // Test error alert
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
    
    func testDeletionTask() {
        app.tabBars.buttons["Tasks"].tap()
        let tasksTable = app.tables.element(boundBy: 0)
        
        XCTAssertTrue(tasksTable.cells.count > 0)
        
        let cellCountBeforeDelete = app.tables.element(boundBy: 0).cells.count
        
        let firstCell = tasksTable.cells.element(boundBy: 0)
        firstCell.swipeLeft()
        firstCell.buttons["Delete"].tap()
        
        let cellCountAfterDelete = app.tables.element(boundBy: 0).cells.count
        let shouldBeAfterDeletionCellCount = cellCountAfterDelete + 1
        
        XCTAssertEqual(cellCountBeforeDelete, shouldBeAfterDeletionCellCount)
    }
    
    func testEditionTask() {
        app.tabBars.buttons["Tasks"].tap()
        
        let cellCountBeforeEdit = app.tables.element(boundBy: 0).cells.count
        
        let tasksTable = app.tables.element(boundBy: 0)
        XCTAssertTrue(tasksTable.cells.count > 0)
        
        let firstCell = tasksTable.cells.element(boundBy: 0)
        firstCell.swipeLeft()
        firstCell.buttons["Edit"].tap()
        
        let taskEditTitle = "Edit task test"
        let taskTitleTextField = app.textFields["TaskTitle"]
        taskTitleTextField.clearAndEnterText(text: taskEditTitle)
        
        let contentTextView = app.textViews["ContentTextView"]
        contentTextView.tap()
        contentTextView.clearAndEnterText(text: "Task edit content test")
        
        var tablesQuery = app.tables
        
        var taskPriorityAfterEdit = "high"
        if tablesQuery.staticTexts["medium"].exists {
            tablesQuery.staticTexts["medium"].tap()
        } else if tablesQuery.staticTexts["high"].exists {
            tablesQuery.staticTexts["high"].tap()
            taskPriorityAfterEdit = "medium"
        } else if tablesQuery.staticTexts["low"].exists {
            tablesQuery.staticTexts["low"].tap()
            taskPriorityAfterEdit = "medium"
        }
        
        tablesQuery.staticTexts[taskPriorityAfterEdit].tap()
        app.navigationBars["Priority"].buttons["Edit Task"].tap()
        app.navigationBars["Edit Task"].buttons["Save"].tap()
        
        let cellCountAfterEdition = app.tables.element(boundBy: 0).cells.count
        
        XCTAssertEqual(cellCountBeforeEdit, cellCountAfterEdition)
        
        tablesQuery = app.tables
        let editedCell = tablesQuery.cells.staticTexts[taskEditTitle]
        
        XCTAssertTrue(editedCell.exists)
    }
    
}

extension XCUIElement {
    
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = stringValue.characters.map({ _ in XCUIKeyboardKeyDelete }).joined(separator: "")
        self.typeText(deleteString)
        self.typeText(text)
    }
    
}
