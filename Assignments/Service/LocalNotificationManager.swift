//
//  ReminderService.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager: ReminderService {
    static let sharedInstance = LocalNotificationManager()
    
    private let center: UNUserNotificationCenter
    
    private init() {
        center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) -> Void in
        })
    }
    
    func createReminder(at date: Date, with title: String, and message: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        center.add(request)
    }
    
    func getReminders(success: @escaping (([Reminder]) -> (Void))) {
        center.getPendingNotificationRequests { notifications in
            var reminders: [Reminder] = []
            notifications.forEach ({
                guard let trigger = $0.trigger as? UNTimeIntervalNotificationTrigger else {
                    return
                }
                
                reminders.append(Reminder(fireDate: Date().addingTimeInterval(trigger.timeInterval)))
            })
            success(reminders)
        }
    }
}
