//
//  AssignmentsTests.swift
//  AssignmentsTests
//
//  Created by Andrey Sak on 3/18/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import XCTest
@testable import Assignments

class AssignmentsTests: XCTestCase {
    
    var controllerForTest: CreateTaskViewController!
    
    override func setUp() {
        super.setUp()
        
        controllerForTest = UIStoryboard(name: "Tasks", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
    }
    
    override func tearDown() {
        controllerForTest = nil
        
        super.tearDown()
    }
    
    func testExample() {
        let taskTitleCell = controllerForTest.taskFieldsTableView
            .cellForRow(at: IndexPath(row: 0, section: 0)) as? TitleTableViewCell
        
        taskTitleCell?.value = "Task Title Name"
        
        let startDateCell = controllerForTest.taskFieldsTableView
            .cellForRow(at: IndexPath(row: 5, section: 0)) as? SelectDateTableViewCell
        
        startDateCell?.value = Date()
        
        XCTAssertEqual(controllerForTest.taskPrototype.title, "Task Title Name")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
