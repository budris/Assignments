//
//  ReminderContainer.swift
//  Assignments
//
//  Created by Andrey Sak on 5/21/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

class ReminderContainer {    
    static let sharedInstance = ReminderContainer()
    
    private var selectedReminder: Reminder?
    
    private init() {
        selectedReminder = nil
    }
    
    func setSelectedReminder(_ newValue: Reminder) {
        selectedReminder = newValue
    }
    
    func getSelectedReminder() -> Reminder? {
        return selectedReminder
    }
    
}
