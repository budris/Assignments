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
    
    var tasks: [Task]?
    
    var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        return fetchRequest
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            tasks = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [Task]
            tasksTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
            guard let task = self.tasks?[indexPath.row] else {
                return
            }
            
            CoreDataManager.instance.managedObjectContext.delete(task)
            CoreDataManager.instance.saveContext()
            self.tasks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullTaskTableViewCell",
                                                       for: indexPath) as? FullTaskTableViewCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = tasks?[indexPath.row].title
        
        return cell
    }
    
}
