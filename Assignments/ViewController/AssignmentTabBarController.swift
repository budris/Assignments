//
//  AssignmentsTabBarViewContriller.swift
//  Assignments
//
//  Created by Sak, Andrey2 on 5/29/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

enum TabBarView: Int {
    case calendar = 0
    case statistic
    case reminders
    case tasks

    static func getTabBarView(for shortcutAction: ShortcutAction) -> TabBarView {
        switch shortcutAction {
        case .openCalendar:
            return .calendar
        case .openStatistic:
            return .statistic
        case .openReminders:
            return .reminders
        case .createTask:
            return .tasks
        }
    }
}

class AssignmentsTabBarController: UITabBarController {

    let shortcutContainer = ShortcutContainer.sharedInstance
    let remindersContainer = ReminderContainer.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectShortcutAction),
                                               name: .selectShortcutAction,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectReminder),
                                               name: .selectReminderAction,
                                               object: nil)


    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .selectShortcutAction, object: nil)
        NotificationCenter.default.removeObserver(self, name: .selectReminderAction, object: nil)
    }

    func didSelectShortcutAction() {
        if let shortcutAction = shortcutContainer.getSelectedAction(),
            let viewControllers = self.viewControllers {
            let tabBarView = TabBarView.getTabBarView(for: shortcutAction)
            self.selectedViewController = viewControllers[tabBarView.rawValue]
        }
    }

    func didSelectReminder() {
        if let _ = remindersContainer.getSelectedReminder(),
            let viewControllers = self.viewControllers {
            self.selectedViewController = viewControllers[TabBarView.reminders.rawValue]
        }
    }

}
