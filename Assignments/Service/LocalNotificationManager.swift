//
//  ReminderService.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import UserNotifications

enum ReminderKey {
    static let taskId: String = "TaskId"
}

class LocalNotificationManager {
    static let sharedInstance = LocalNotificationManager()
    
    fileprivate let center: UNUserNotificationCenter
    
    private init() {
        center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, error) -> Void in
        })
    }
}

extension LocalNotificationManager: ReminderService {

    func createReminder(at date: Date, with title: String, and message: String, for taskId: Int, repeats: Bool) {
        // создание и заполнение содержимого уведомления
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = UNNotificationSound.default()
        content.userInfo[ReminderKey.taskId] = taskId
        
        // создание даты и времени напоминания
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow,
                                                        repeats: repeats)
        // создание запроса на напоминания
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        // добавление запроса в очередь на выполнение
        center.add(request)  
    }
    
    func getReminders(success: @escaping (([Reminder]) -> (Void))) {
        center.getPendingNotificationRequests { notifications in
            var reminders: [Reminder] = []
            // преобразование системных напоминаний 
            // к пользовательскому типу данных
            notifications.forEach ({
                guard let trigger = $0.trigger as? UNTimeIntervalNotificationTrigger,
                    let taskId = $0.content.userInfo[ReminderKey.taskId] as? Int else {
                    return
                }
                
                reminders.append(Reminder(identifier: $0.identifier,
                                          taskId: taskId,
                                          fireDate: Date().addingTimeInterval(trigger.timeInterval)))
            })
            success(reminders)
        }
    }
    
    func removeReminder(withIdentifiers: [String]) {
        center.removePendingNotificationRequests(withIdentifiers: withIdentifiers)
    }
}
