//
//  CreateTaskViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    
    fileprivate enum CreateTaskField {
        case title
        case subject
        case status
        case content
        case priority
        case startDate
        case endData
        case attachments
    }
    
    @IBOutlet weak var taskFieldsTableView: UITableView!
    
    fileprivate let taskService: TaskService = CoreDataTasksManager.instance
    
    fileprivate var taskFieldsDataSource: [CreateTaskField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskFieldsTableView.dataSource = self
        taskFieldsTableView.delegate = self
        
        generateDataSource()
    }
    
    private func generateDataSource() {
        taskFieldsDataSource = [
            .title,
            .subject,
            .status,
            .content,
            .priority,
            .startDate,
            .endData
        ]
    }
    
    @IBAction func createAction(_ sender: Any) {
        taskService.createTask(title: "title")
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? SelectFieldViewController else {
            return
        }
        
        destinationVC.selectionFields = PriorityEnum.allValues
        destinationVC.selectedFields = [PriorityEnum.medium]
    }
    
}

extension CreateTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskFieldsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = taskFieldsDataSource[indexPath.row]
        
        var cell: UITableViewCell!
        
        switch type {
        case .title:
            cell = titleTableViewCell(tableView, for: indexPath)
        case .subject, .status, .priority:
            cell = selectionTableViewCell(tableView, for: indexPath, for: type)
        case .startDate, .endData:
            cell = selectDateTableViewCell(tableView, for: indexPath, for: type)
            
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func titleTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? TitleTableViewCell else {
                                                        return UITableViewCell()
        }
        
        return cell
    }
    
    fileprivate func selectionTableViewCell(_ tableView: UITableView, for indexPath: IndexPath, for type: CreateTaskField) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectionTableViewCell else {
                                                        return UITableViewCell()
        }
        
        var title = ""
        
        switch type {
        case .subject:
            title = "Subject"
        case .priority:
            title = "Priority"
        case .status:
            title = "Status"
        default:
            title = "Undefined"
        }
        
        cell.titleLabel.text = title
        
        return cell
    }
    
    func dateTimeTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTimeTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DateTimeTableViewCell else {
                                                        return UITableViewCell()
        }
        
        return cell
    }
    
    fileprivate func selectDateTableViewCell(_ tableView: UITableView, for indexPath: IndexPath, for type: CreateTaskField) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectDateTableViewCell else {
                                                        return UITableViewCell()
        }
        
        var title = ""
        
        switch type {
        case .startDate:
            title = "Start Date"
        case .endData:
            title = "End Date"
        default:
            title = "Undefuned"
        }
        
        cell.titleLabel.text = title
        
        return cell
    }
    
}

extension CreateTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectField", sender: self)
    }
    
}

