//
//  TaskService.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

protocol TaskService {
    var tasks: [Task] { get }
    
    func createTask(taskPrototype: TaskPrototype) -> Task
    func updateTask(taskPrototype: TaskPrototype) -> Task?
    func deleteTask(task: Task)
}
