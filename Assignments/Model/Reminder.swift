//
//  Reminder.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

class Reminder {
    let fireDate: Date
    let taskId: Int
    let identifier: String
    
    init(identifier: String, taskId: Int, fireDate: Date) {
        self.identifier = identifier
        self.taskId = taskId
        self.fireDate = fireDate
    }
}
