//
//  AppDelegate.swift
//  Assignments
//
//  Created by Andrey Sak on 3/18/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    private func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutAction = ShortcutAction(rawValue: shortcutType) else {
            return false
        }
        
        ShortcutContainer.sharedInstance.setSelectedAction(shortcutAction)
        return true
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        guard let reminder = reminder(for: notification) else {
            return
        }
        
        ReminderContainer.sharedInstance.setSelectedReminder(reminder)
    }
    
    private func reminder(for localNotification: UILocalNotification) -> Reminder? {
        guard let taskId = localNotification.userInfo?[ReminderKey.taskId] as? Int,
            let fireDate = localNotification.fireDate else {
                return nil
        }
        
        return Reminder(identifier: "", taskId: taskId, fireDate: fireDate)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.instance.saveContext()
    }
    
}

