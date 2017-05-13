//
//  TasksViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tasksTableView: UITableView!
    @IBOutlet weak var subjectsFilterBar: ScrollableSegmentedControl!
    @IBOutlet weak var filterBarHeightConstraint: NSLayoutConstraint!
    
    fileprivate let taskService: TaskService = CoreDataTasksManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasksTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            guard let navVC = segue.destination as? UINavigationController,
                let editTaskVC = navVC.topViewController as? CreateTaskViewController,
                let task = sender as? Task else {
                    return
            }
            
            editTaskVC.editedTask = task
            editTaskVC.didUpdatedTask = { [weak self] task in
                guard let index = self?.taskService.tasks.index(where: { $0.id == task.id }) else {
                    return
                }
                
                self?.tasksTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    

    
    private func setupSubjectsFilterBar() {
        filterBarHeightConstraint.constant = false ? 50.0 : 0.0
    }
    
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            guard let task = self?.taskService.tasks[indexPath.row] else {
                return
            }
            
            self?.taskService.deleteTask(task: task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (_, indexPath) in
            guard let task = self?.taskService.tasks[indexPath.row] else {
                return
            }
            
            self?.performSegue(withIdentifier: "editTask", sender: task)
        }
        editAction.backgroundColor = UIColor(red: 12/255, green: 154/255, blue: 215/255, alpha: 1)
        
        return [deleteAction, editAction]
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskService.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullTaskTableViewCell",
                                                       for: indexPath) as? FullTaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = taskService.tasks[indexPath.row]
        
        cell.title = task.title
        cell.status = task.status?.statusEnum
        cell.priority = task.priority?.prioprityEnum
        
        return cell
    }
    
}
