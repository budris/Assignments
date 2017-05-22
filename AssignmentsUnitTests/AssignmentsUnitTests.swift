//
//  AssignmentsUnitTests.swift
//  AssignmentsUnitTests
//
//  Created by Andrey Sak on 5/22/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import XCTest
@testable import Assignments

class AssignmentsUnitTests: XCTestCase {
    
    var controllerForTest: CreateTaskViewController!
    
    override func setUp() {
        super.setUp()
        
        controllerForTest = UIStoryboard(name: "Tasks", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
    }
    
    override func tearDown() {
        controllerForTest = nil
        
        super.tearDown()
    }
    
    func testTaskValidation() {
        controllerForTest = UIStoryboard(name: "Tasks", bundle: nil).instantiateViewController(withIdentifier: "CreateTaskViewController") as! CreateTaskViewController
        
        controllerForTest.taskPrototype.title = "Task Name"
        controllerForTest.taskPrototype.startDate = Date() as NSDate
        controllerForTest.taskPrototype.durationInMinutes = 120
        controllerForTest.taskPrototype.priority = .medium
        controllerForTest.taskPrototype.status = .postponed
        
        let isValid = controllerForTest.isValidTaskPrototype(taskPrototype: controllerForTest.taskPrototype)
        XCTAssert(isValid, "Task Prototype is not valid")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

