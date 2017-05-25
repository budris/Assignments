//
//  TasksViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import AVKit
import SKPhotoBrowser

class TasksViewController: UIViewController {
    @IBOutlet weak var tasksTableView: UITableView!
    
    fileprivate let taskService: TaskService = CoreDataTasksManager.sharedInstance
    
    fileprivate var priorityFilter: PriorityEnum?
    fileprivate var tasks: [Task] {
        get {
            var tasks = taskService.tasks
            if let priorityFilter = priorityFilter {
                tasks = tasks.filter({ $0.priority?.prioprityEnum == priorityFilter })
            }
            return tasks
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
        setupNavigationDropdownMenu()        
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
    
    fileprivate func didSelectAttachment(attachemnt: Attachment) {
        guard let attachmentType = attachemnt.type else {
            return
        }
        
        switch attachmentType.typeEnum {
        case .image:
            guard let imageData = attachemnt.data as Data?,
                let image = UIImage(data: imageData as Data) else {
                    return
            }
            
            let browser = SKPhotoBrowser(photos: [SKPhoto.photoWithImage(image)])
            browser.delegate = self
            present(browser, animated: true, completion: nil)
        case .video:
            guard let videoData = attachemnt.data as Data?,
                let fileName = attachemnt.name,
                let filePath = documentsPathForFileName(fileName) else {
                return
            }
            
            let fileURL = URL(fileURLWithPath: filePath)
            let isFileExists = FileManager.default.fileExists(atPath: filePath)
            if !isFileExists {
                do {
                    try videoData.write(to: fileURL, options: .atomic)
                } catch {
                    showError(with: error.localizedDescription)
                }
            }
            
            let player = AVPlayer(url: fileURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    private func documentsPathForFileName(_ fileName: String) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                        FileManager.SearchPathDomainMask.userDomainMask,
                                                        true)
        guard let documentsPath = paths.first else {
            return nil
        }
        
        return documentsPath.appending(fileName)
    }
    
    private func setupNavigationDropdownMenu() {
        var items = ["All"]
        items.append(contentsOf: PriorityEnum.allValues.map({ $0.descriptionField.capitalized }))
        
        let menuView = NavigationDropdownMenu(navigationController: navigationController, containerView: navigationController!.view, title: items[0], items: items as [AnyObject], bottomOffset: 44.0)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 14.0)
        menuView.cellTextLabelAlignment = .center
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = { [weak self] index in
            defer {
                self?.tasksTableView.reloadData()
            }
            
            let item = items[index]
            guard let priority = PriorityEnum.priority(by: item.lowercased()) else {
                self?.priorityFilter = nil
                return
            }
            
            self?.priorityFilter = priority
        }
        
        navigationItem.titleView = menuView
    }
    
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, indexPath) in
            guard let task = self?.tasks[indexPath.row] else {
                return
            }
            
            self?.taskService.deleteTask(task: task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { [weak self] (_, indexPath) in
            guard let task = self?.tasks[indexPath.row] else {
                return
            }
            
            self?.performSegue(withIdentifier: "editTask", sender: task)
        }
        
        let exportAction = UITableViewRowAction(style: .normal, title: "Export") { [weak self] (_, indexPath) in
            self?.performSegue(withIdentifier: "exportEvent", sender: self)
        }
        exportAction.backgroundColor = UIColor.cyan
        
        editAction.backgroundColor = UIColor(red: 12/255, green: 154/255, blue: 215/255, alpha: 1)
        
        return [deleteAction, editAction, exportAction]
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullTaskTableViewCell",
                                                       for: indexPath) as? FullTaskTableViewCell else {
            return UITableViewCell()
        }
        
        let task = tasks[indexPath.row]
        
        cell.title = task.title
        cell.status = task.status?.statusEnum
        cell.priority = task.priority?.prioprityEnum
        
        if let attachments = task.attachments?.allObjects as? [Attachment] {
            cell.attachments = attachments
            cell.didSelectAttachment = { [weak self] attachment in
                self?.didSelectAttachment(attachemnt: attachment)
            }
        }
        
        return cell
    }
    
}

extension TasksViewController: SKPhotoBrowserDelegate {
    
    func didDismissAtPageIndex(_ index: Int) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
}
