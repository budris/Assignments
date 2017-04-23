//
//  CreateTaskViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

enum TaskField {
    case title
    case subject
    case status
    case content
    case priority
    case startDate
    case endDate
    case attachments
    
    var description: String {
        switch self {
        case .title:
            return "Title"
        case .subject:
            return "Subject"
        case .status:
            return "Status"
        case .content:
            return "Content"
        case .priority:
            return "Priority"
        case .startDate:
            return "Start Date"
        case .endDate:
            return "Title"
        case .attachments:
            return "Attachments"
        }
    }
}

struct TaskPrototype {
    public var title: String?
    public var content: String?
    public var dateCreation: NSDate?
    public var startDate: NSDate?
    public var endDate: NSDate?
    public var status: Status?
    public var priority: PriorityEnum
    public var attachments: NSSet?
    public var subject: Subject?
    
    init() {
        priority = .medium
    }
}

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskFieldsTableView: UITableView!
    
    fileprivate let taskService: TaskService = CoreDataTasksManager.instance
    
    fileprivate var taskFieldsDataSource: [TaskField] = []
    fileprivate var taskPrototype = TaskPrototype()
    
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
            .endDate
        ]
    }
    
    @IBAction func createAction(_ sender: Any) {
        CoreDataManager.instance.saveContext()
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let type = sender as? TaskField {
            guard let destinationVC = segue.destination as? SelectFieldViewController else {
                return
            }
            
            prepareSelectFieldViewController(destinationVC, for: type)
            
            
            
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func prepareSelectFieldViewController(_ viewController: SelectFieldViewController, for type: TaskField) {
        weak var weakSelf = self
        switch type {
        case .priority:
            viewController.selectionFields = PriorityEnum.allValues
            viewController.selectedFields = [taskPrototype.priority]
            viewController.onDismissCallback = { selectedFields -> () in
                guard let selectedPriority = selectedFields.first as? PriorityEnum,
                    let priorityIndex = weakSelf?.taskFieldsDataSource.index(of: TaskField.priority) else {
                    return
                }
                
                weakSelf?.taskPrototype.priority = selectedPriority
                weakSelf?.taskFieldsTableView.reloadRows(at: [IndexPath(row: priorityIndex, section: 0)],
                                                         with: .automatic)
            }
        default:
            return
//            destinationVC.selectionFields = []
//            destinationVC.selectedFields = [PriorityEnum.medium]
        }
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
        case .startDate, .endDate:
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
    
    fileprivate func selectionTableViewCell(_ tableView: UITableView, for indexPath: IndexPath, for type: TaskField) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectionTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectionTableViewCell else {
                                                        return UITableViewCell()
        }
        
        cell.setup(with: type, taskPrototype: taskPrototype)
        
        return cell
    }
    
    func dateTimeTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTimeTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? DateTimeTableViewCell else {
                                                        return UITableViewCell()
        }
        
        return cell
    }
    
    fileprivate func selectDateTableViewCell(_ tableView: UITableView, for indexPath: IndexPath, for type: TaskField) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectDateTableViewCell else {
                                                        return UITableViewCell()
        }
        
        var title = ""
        
        switch type {
        case .startDate:
            title = "Start Date"
        case .endDate:
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
        let cellType = taskFieldsDataSource[indexPath.row]
        switch cellType {
        case .priority, .status, .subject:
            performSegue(withIdentifier: "selectField", sender: cellType)
        default:
            return
        }
    }
    
}

