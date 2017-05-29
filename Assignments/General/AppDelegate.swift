//
//  AppDelegate.swift
//  Assignments
//
//  Created by Andrey Sak on 3/18/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import Google
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        GIDSignIn.sharedInstance().clientID = "236844990219-823cei0bo6ivgq63mm9qm3svao8fo6li.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self

        UNUserNotificationCenter.current().delegate = self
        
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
        NotificationCenter.default.post(name: .selectShortcutAction, object: nil)
        return true
    }
    
    fileprivate func reminder(for notificationRequest: UNNotificationRequest) -> Reminder? {
        guard let taskId = notificationRequest.content.userInfo[ReminderKey.taskId] as? Int else {
                return nil
        }
        
        return Reminder(identifier: "", taskId: taskId, fireDate: Date())
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.instance.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
}

extension AppDelegate : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
     print(error)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print(error)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        let notification = response.notification
        guard let reminder = reminder(for: notification.request) else {
            return
        }

        ReminderContainer.sharedInstance.setSelectedReminder(reminder)
        NotificationCenter.default.post(name: .selectReminderAction, object: nil)
    }

}
