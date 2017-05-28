//
//  TasksServiceUnitTest.swift
//  Assignments
//
//  Created by Andrey Sak on 5/28/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import XCTest
@testable import Assignments

class TasksServiceUnitTest: XCTestCase {
    
    let taskService: TaskService = CoreDataTasksManager.sharedInstance
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testService() {
        testCreate()
        testEdite()
        testDelete()
    }
    
    func testCreate() {
        let tasksCountBeforeCreation = taskService.tasks.count
        // создание тестового прототипа задания
        let taskPrototype = createTestTaskPrototype()
        // создание задания в базе данных
        let _ = taskService.createTask(taskPrototype: taskPrototype)
        
        let tasksCountAfterCreation = taskService.tasks.count
        
        XCTAssertTrue(tasksCountBeforeCreation != tasksCountAfterCreation,
                      "Task doesn`t created")
    }
    
    func testEdite() {
        XCTAssertTrue(taskService.tasks.count > 0,
                      "Tasks not found. Count must be greater then 0")
        
        let taskForEdit = taskService.tasks.first!
        let taskPrototype = self.editedTaskPrototypeFrom(task: taskForEdit)
        
        let titleBeforeEdit = taskForEdit.title
        let contentBeforeEdit = taskForEdit.content
        let dateBeforeEdit = taskForEdit.startDate
        let statusBeforeEdit = taskForEdit.status?.statusEnum
        let priorityBeforeEdit = taskForEdit.priority?.prioprityEnum
        let durationInMinutesBeforeEdit = taskForEdit.durationInMinutes
        
        guard let editedTask = taskService.updateTask(taskPrototype: taskPrototype) else {
            XCTAssertTrue(false, "Task doesnt update")
            return
        }
        
        XCTAssertTrue(titleBeforeEdit != editedTask.title,
                      "Tasks title doesn't update")
        XCTAssertTrue(contentBeforeEdit != editedTask.content,
                      "Tasks content doesn't update")
        XCTAssertTrue(dateBeforeEdit != editedTask.startDate,
                      "Tasks date doesn't update")
        XCTAssertTrue(statusBeforeEdit != editedTask.status?.statusEnum,
                      "Tasks status doesn't update")
        XCTAssertTrue(priorityBeforeEdit != editedTask.priority?.prioprityEnum,
                      "Tasks priority doesn't update")
        XCTAssertTrue(durationInMinutesBeforeEdit != editedTask.durationInMinutes,
                      "Tasks durationInMinutes doesn't update")
    }
    
    
    func testDelete() {
        XCTAssertTrue(taskService.tasks.count > 0,
                      "Tasks not found. Count must be greater then 0")
        
        let taskForDelete = taskService.tasks.first!
        let tasksCountBeforeDeletion = taskService.tasks.count
        
        taskService.deleteTask(task: taskForDelete)
        
        let tasksCountAfterDeletion = taskService.tasks.count
        
        XCTAssertTrue(tasksCountBeforeDeletion != tasksCountAfterDeletion, "Task doesn`t delete")
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func createTestTaskPrototype() -> TaskPrototype {
        var taskPrototype = TaskPrototype()
        taskPrototype.startDate = Date() as NSDate
        taskPrototype.title = "Test title"
        taskPrototype.content = "Test content"
        taskPrototype.durationInMinutes = 100
        taskPrototype.priority = .high
        taskPrototype.status = .inProgress
        
        return taskPrototype
    }
    
    private func editedTaskPrototypeFrom(task: Task) -> TaskPrototype {
        var taskPrototype = TaskPrototype()
        taskPrototype.id = Int(task.id)
        taskPrototype.startDate = Date() as NSDate
        taskPrototype.title = "Edit title"
        taskPrototype.content = "Edit content"
        taskPrototype.durationInMinutes = 120
        taskPrototype.priority = .low
        taskPrototype.status = .postponed
        
        return taskPrototype
    }
    
}
