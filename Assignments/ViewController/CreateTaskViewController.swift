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
    case dateTimePicker
    
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
        case .dateTimePicker:
            return "DateTimePicker"
        }
    }
}

struct TaskPrototype {
    public var title: String?
    public var content: String?
    public var dateCreation: NSDate?
    public var startDate: NSDate?
    public var endDate: NSDate?
    public var status: StatusEnum
    public var priority: PriorityEnum
    public var attachments: NSSet?
    public var subject: Subject?
    
    init() {
        priority = .medium
        status = .toDo
    }
}

class CreateTaskViewController: UIViewController {
    @IBOutlet weak var taskFieldsTableView: UITableView!
    
    fileprivate let taskService: TaskService = CoreDataTasksManager.instance
    fileprivate let subjectService: SubjectService = CoreDataSubjectManager.sharedInstance
    
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
            viewController.title = type.description
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
        case .status:
            viewController.title = type.description
            viewController.selectionFields = StatusEnum.allValues
            viewController.selectedFields = [taskPrototype.status]
            viewController.onDismissCallback = { selectedFields -> () in
                guard let selectedStatus = selectedFields.first as? StatusEnum,
                    let statusIndex = weakSelf?.taskFieldsDataSource.index(of: TaskField.status) else {
                        return
                }
                
                weakSelf?.taskPrototype.status = selectedStatus
                weakSelf?.taskFieldsTableView.reloadRows(at: [IndexPath(row: statusIndex, section: 0)],
                                                         with: .automatic)
            }
        case .subject:
            viewController.title = type.description
            viewController.selectionFields = subjectService.subjects
            if let selectedSubject = taskPrototype.subject {
                viewController.selectedFields = [selectedSubject]
            }
            viewController.onDismissCallback = { selectedFields -> () in
                guard let selectedSubject = selectedFields.first as? Subject,
                    let subjectIndex = weakSelf?.taskFieldsDataSource.index(of: TaskField.subject) else {
                        return
                }
                
                weakSelf?.taskPrototype.subject = selectedSubject
                weakSelf?.taskFieldsTableView.reloadRows(at: [IndexPath(row: subjectIndex, section: 0)],
                                                         with: .automatic)
            }
        default:
            return
//            destinationVC.selectionFields = []
//            destinationVC.selectedFields = [PriorityEnum.medium]
        }
    }
    
    fileprivate func showCreateSubjectAlert() {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let createSubjectAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            self?.performSegue(withIdentifier: "createSubject", sender: self)
        }
        
        let createSubjectAlert = UIAlertController(title: nil,
                                                   message: "You don`t have any subjects.",
                                                   preferredStyle: .alert)
        
        createSubjectAlert.addAction(cancelAction)
        createSubjectAlert.addAction(createSubjectAction)
        
        present(createSubjectAlert, animated: true)
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
        case .dateTimePicker:
            cell = dateTimeTableViewCell(tableView, for: indexPath)
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
        
        cell.placeholder = "Task Title"
        cell.value = taskPrototype.title
        
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
        case .priority, .status:
            performSegue(withIdentifier: "selectField", sender: cellType)
        case .subject:
            if subjectService.subjects.isEmpty {
                showCreateSubjectAlert()
            } else {
                performSegue(withIdentifier: "selectField", sender: cellType)
            }
        case .startDate:
            didSelectDateCell(at: tableView, with: .startDate)
        case .endDate:
            didSelectDateCell(at: tableView, with: .endDate)
        default:
            return
        }
    }
    
    private func didSelectDateCell(at tableView: UITableView, with type: TaskField) {
        tableView.beginUpdates()
        
        defer {
            tableView.endUpdates()
        }
        
        if let datePickerIndex = taskFieldsDataSource.index(of: .dateTimePicker) {
            let datePickerIndexPath = IndexPath(row: datePickerIndex, section: 0)
            guard let cell = tableView.cellForRow(at: datePickerIndexPath) as? DateTimeTableViewCell else {
                return
            }
            
            var dateTimeIndexPath: IndexPath?
            switch type {
            case .startDate:
                taskPrototype.startDate = cell.dateTimePicker.date as NSDate
                dateTimeIndexPath = IndexPath(row: taskFieldsDataSource.index(of: type)!, section: 0)
            case .endDate:
                taskPrototype.endDate = cell.dateTimePicker.date as NSDate
                dateTimeIndexPath = IndexPath(row: taskFieldsDataSource.index(of: type)!, section: 0)
            default:
                break
            }
            
            if let indexPathForReload = dateTimeIndexPath {
                tableView.reloadRows(at: [indexPathForReload], with: .automatic)
            }
            taskFieldsDataSource.remove(at: datePickerIndex)
            tableView.deleteRows(at: [datePickerIndexPath], with: .automatic)
        } else {
            guard let indexDateTimeCell = taskFieldsDataSource.index(of: type) else {
                return
            }
            
            taskFieldsDataSource.insert(.dateTimePicker, at: indexDateTimeCell + 1)
            tableView.insertRows(at: [IndexPath(row: indexDateTimeCell + 1, section: 0)], with: .automatic)
        }
        
    }
    
}

