//
//  ReminderServiceUnitTest.swift
//  Assignments
//
//  Created by Andrey Sak on 5/28/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import XCTest
@testable import Assignments

class ReminderServiceUnitTest: XCTestCase {
    
    let reminderService = LocalNotificationManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testService() {
        // создание напоминания
        let testTaskId = 123456
        reminderService.createReminder(at: Date().addingTimeInterval(150),
                                       with: "Test",
                                       and: "test",
                                       for: testTaskId,
                                       repeats: false)
        let expectationReminders = expectation(description: "expectationReminders")
        
        var testReminder: Reminder?
        
        // получение списка напоминаний
        reminderService.getReminders { reminders -> (Void) in
            // проверка созданиния напоминания
            guard let createdReminder = reminders.first(where: { $0.taskId == testTaskId }) else {
                XCTFail("Reminder doesn`t create")
                return
            }
            
            testReminder = createdReminder
            expectationReminders.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let testReminder = testReminder else {
                XCTFail("Reminder doesn`t create")
                return
            }
            // удаления напоминания
            self.reminderService.removeReminder(withIdentifiers: [testReminder.identifier])
            
            let expectationReminders = self.expectation(description: "expectationReminders")
            
            self.reminderService.getReminders { reminders -> (Void) in
                // проверка удаления напоминания
                let isReminderExist = reminders.contains(where: { $0.taskId == testTaskId })
                XCTAssertFalse(isReminderExist,
                              "Reminder doesn`t delete")
                expectationReminders.fulfill()
            }
        }
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
