//
//  RemindersViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RemindersViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var remindersTableView: UITableView!
    
    fileprivate let reminderService: ReminderService = LocalNotificationManager.sharedInstance
    fileprivate let taskService: TaskService = CoreDataTasksManager.sharedInstance
    
    var reminders: [Reminder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remindersTableView.dataSource = self
        remindersTableView.delegate = self
        
        subscribeForNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reminders.removeAll()
        remindersTableView.reloadData()
        
        let indicatorFrame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
        
        let activityIndicator = NVActivityIndicatorView(frame: indicatorFrame,
                                                        type: NVActivityIndicatorType.ballClipRotate,
                                                        color: UIColor.darkGray,
                                                        padding: nil)
        activityIndicator.center = view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        reminderService.getReminders { [weak self] reminders -> (Void) in
            self?.reminders = reminders
            self?.remindersTableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            guard let navVC = segue.destination as? UINavigationController,
                let editTaskVC = navVC.topViewController as? CreateTaskViewController,
                let task = sender as? Task else {
                    return
            }

            editTaskVC.editedTask = task
            editTaskVC.didUpdatedTask = { [weak self] _ in
                self?.remindersTableView.reloadData()
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func subscribeForNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectReminder),
                                               name: .selectReminderAction,
                                               object: nil)
    }

    func didSelectReminder() {
        if let reminder = ReminderContainer.sharedInstance.getSelectedReminder() {
            guard let task = taskService.tasks.first(where: { Int($0.id) == reminder.taskId })else {
                return
            }

            performSegue(withIdentifier: "editTask", sender: task)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .selectReminderAction, object: nil)
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
        
        let reminder = reminders[indexPath.row]
        
        if let task = taskService.tasks.first(where: { Int($0.id) == reminder.taskId }) {
            cell.titleValue = task.title
        } else {
            cell.titleValue = "Not found"
        }
        
        cell.timeLabel.text = reminder.fireDate.formattedDateDescription()
        
        return cell
    }
    
}

extension RemindersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            guard let reminder = self?.reminders[indexPath.row] else {
                return
            }
            
            self?.reminderService.removeReminder(withIdentifiers: [reminder.identifier])
            self?.reminders.remove(at: indexPath.row)
            self?.remindersTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = reminders[indexPath.row]

        guard let task = taskService.tasks.first(where: { Int($0.id) == reminder.taskId })else {
            return
        }

        performSegue(withIdentifier: "editTask", sender: task)        
    }
    
}
