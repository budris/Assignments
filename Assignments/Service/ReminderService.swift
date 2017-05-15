//
//  ReminderService.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

protocol ReminderService {
    func createReminder(at date: Date, with title: String, and message: String, for taskId: Int)
    func getReminders(success: @escaping (([Reminder]) -> (Void)))
    func removeReminder(withIdentifiers: [String])
}
