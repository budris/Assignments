//
//  RemindersViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class RemindersViewController: UIViewController {
    
    @IBOutlet weak var remindersTableView: UITableView!
    
    fileprivate let reminderService = LocalNotificationManager.sharedInstance
    
    var reminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remindersTableView.dataSource = self
//        remindersTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminderService.getReminders { [weak self] reminders -> (Void) in
            self?.reminders = reminders
            self?.remindersTableView.reloadData()
        }
    }
}

extension RemindersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReminderTableViewCell.reuseIdentifier, for: indexPath) as? ReminderTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = "text"
        cell.timeLabel.text = reminders[indexPath.row].fireDate.formattedDateDescription()
        
        return cell
    }
    
}
