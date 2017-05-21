//
//  CreateTaskViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import CoreActionSheetPicker
import MobileCoreServices.UTType

enum TaskField {
    case title
    case status
    case content
    case priority
    case startDate
    case durationInMinutes
    case attachments
    
    var description: String {
        switch self {
        case .title:
            return "Title"
        case .status:
            return "Status"
        case .content:
            return "Content"
        case .priority:
            return "Priority"
        case .startDate:
            return "Start Date"
        case .durationInMinutes:
            return "Duration In Minutes"
        case .attachments:
            return "Attachments"
        }
    }
}

struct TaskPrototype {
    public var id: Int?
    public var title: String?
    public var content: String?
    public var dateCreation: NSDate?
    public var startDate: NSDate?
    public var durationInMinutes: Double?
    public var status: StatusEnum
    public var priority: PriorityEnum
    public var attachments: NSSet?
    
    init() {
        priority = .medium
        status = .toDo
    }
}

class CreateTaskViewController: UIViewController {
    static let minPickerDate: Date = Date().addingTimeInterval(-10000000)
    static let maxPickerDate: Date = Date().addingTimeInterval(10000000)
    
    private enum WorkingType {
        case create
        case edit
    }
    
    @IBOutlet weak var taskFieldsTableView: UITableView!
    
    fileprivate let taskService: TaskService = CoreDataTasksManager.sharedInstance
    fileprivate let reminderService = LocalNotificationManager.sharedInstance
    
    fileprivate var taskFieldsDataSource: [TaskField] = []
    var taskPrototype = TaskPrototype()
    
    public var editedTask: Task?
    public var didUpdatedTask: ((_ task: Task) -> ())?
    
    private var workingType: WorkingType = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = editedTask {
            workingType = .edit
            
            taskPrototype.id = Int(task.id)
            taskPrototype.title = task.title
            taskPrototype.title = task.title
            taskPrototype.dateCreation = task.dateCreation
            taskPrototype.content = task.content
            taskPrototype.durationInMinutes = task.durationInMinutes
            taskPrototype.startDate = task.startDate
            taskPrototype.attachments = task.attachments
            
            if let priority = task.priority?.prioprityEnum {
                taskPrototype.priority = priority
            }
            if let status = task.status?.statusEnum {
                taskPrototype.status = status
            }
            
            navigationItem.rightBarButtonItem?.title = "Save"
            navigationItem.title = "Edit Task"
        }
        
        taskFieldsTableView.dataSource = self
        taskFieldsTableView.delegate = self
        
        taskFieldsTableView.estimatedRowHeight = 44.0
        taskFieldsTableView.rowHeight = UITableViewAutomaticDimension
        
        generateDataSource()
    }
    
    private func generateDataSource() {
        taskFieldsDataSource = [
            .title,
            .status,
            .content,
            .priority,
            .startDate,
            .durationInMinutes
        ]
    }
    
    @IBAction func createAction(_ sender: Any) {
        view.endEditing(true)
        
        guard !(taskPrototype.title?.isEmpty ?? true) else {
            showError(with: "Task must have title")
            return
        }
        
        switch workingType {
        case .create:
            let task  = taskService.createTask(taskPrototype: taskPrototype)
            if let startDate = taskPrototype.startDate as Date? {
                reminderService.createReminder(at: startDate,
                                               with: taskPrototype.title ?? "", and: "You must to do",
                                               for: Int(task.id))
            }
            
        case .edit:
            if let updatedTask = taskService.updateTask(taskPrototype: taskPrototype) {
                didUpdatedTask?(updatedTask)
            }
        }
        
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func takeAttachmentAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Upload From Camera Roll", style: .default) { action in
            let picker = UIImagePickerController()            
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []

            self.present(picker, animated: true, completion: nil)
        })
        actionSheet.addAction(UIAlertAction(title: "Take Picture/Video", style: .default) { action in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
            
            self.present(picker, animated: true, completion: nil)
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet, animated: true)
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
                                                         with: .fade)
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
                                                         with: .fade)
            }
        default:
            return
        }
    }
    
    fileprivate func showDatePicker(title: String, selectedDate: Date, mode: UIDatePickerMode, durationInMinutes: TimeInterval? = nil, complition: @escaping ActionDateDoneBlock) {
        let actionSheetPicker = ActionSheetDatePicker.show(withTitle: title,
                                   datePickerMode: mode,
                                   selectedDate: selectedDate,
                                   minimumDate: CreateTaskViewController.minPickerDate,
                                   maximumDate: CreateTaskViewController.maxPickerDate,
                                   doneBlock: complition,
                                   cancel: { _ in
        }, origin: view)
        
        if let durationInMinutes = durationInMinutes {
            actionSheetPicker?.countDownDuration = durationInMinutes * 60.0
        }
    }
    
    fileprivate func reloadRow(type: TaskField) {
        guard let index = taskFieldsDataSource.index(of: type) else {
            return
        }
        
        taskFieldsTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
    
    fileprivate func addAttachment(data: NSData, type: AttachmentEnum) {
        let attachment = Attachment()
        attachment.data = data
        attachment.name = UUID().uuidString
        let attachmentType = AttachmentType()
        attachmentType.typeEnum = type
        attachment.type = attachmentType
        
        if var attachments = taskPrototype.attachments?.allObjects as? [Attachment] {
            attachments.append(attachment)
            taskPrototype.attachments = Set(attachments) as NSSet
        } else {
            taskPrototype.attachments = [attachment]
        }
        
        
        if !taskFieldsDataSource.contains(.attachments) {
            taskFieldsDataSource.append(.attachments)
            taskFieldsTableView.reloadData()
        } else {
            reloadRow(type: .attachments)
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
        case .status, .priority:
            cell = selectionTableViewCell(tableView, for: indexPath, for: type)
        case .startDate:
            cell = selectTimeTableViewCell(tableView, for: indexPath)
        case .content:
            cell = contentTableViewCell(tableView, for: indexPath)
        case .durationInMinutes:
            cell = durationTableViewCell(tableView, for: indexPath)
        case .attachments:
            cell = attachmentsTableViewCell(tableView, for: indexPath)
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
        cell.didChangeTitle = { [weak self] title in
            self?.taskPrototype.title = title
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
    
    func selectTimeTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectDateTableViewCell else {
                                                        return UITableViewCell()
        }
        
        cell.title = TaskField.startDate.description
        cell.value = taskPrototype.startDate as Date?
                
        return cell
    }
    
    func durationTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectDateTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectDateTableViewCell else {
            return UITableViewCell()
        }
        
        cell.title = TaskField.durationInMinutes.description
        cell.durationValue = taskPrototype.durationInMinutes
        
        return cell
    }
    
    private func contentTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.reuseIdentifier, for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        cell.content = taskPrototype.content
        cell.placeholder = "Description" 
        cell.didContentChanged = { [weak self] content in
            self?.taskPrototype.content = content
        }
        
        return cell
    }
    
    private func attachmentsTableViewCell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AttachmentTableViewCell.reuseIdentifier, for: indexPath) as? AttachmentTableViewCell,
            let attachments = taskPrototype.attachments?.allObjects as? [Attachment] else {
            return UITableViewCell()
        }
        
        cell.setupAttachments(attachments: attachments)
        
        return cell
    }
    
}

extension CreateTaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = taskFieldsDataSource[indexPath.row]
        switch cellType {
        case .priority, .status:
            performSegue(withIdentifier: "selectField", sender: cellType)
        case .startDate:
            showDatePicker(title: cellType.description,
                           selectedDate: (taskPrototype.startDate as Date?) ?? Date(),
                           mode: .dateAndTime) { [weak self] (picker, selectedDate, _) in
                            guard let selectedDate = selectedDate as? Date else {
                                return
                            }
                            
                            self?.taskPrototype.startDate = selectedDate as NSDate
                            self?.reloadRow(type: cellType)
            }
        case .durationInMinutes:
            showDatePicker(title: cellType.description,
                           selectedDate: Date(),
                           mode: .countDownTimer,
                           durationInMinutes: taskPrototype.durationInMinutes) { [weak self] (picker, countDownTime, _) in
                            guard let durationInSeconds = (countDownTime as? NSNumber)?.doubleValue else {
                                return
                            }
                            
                            self?.taskPrototype.durationInMinutes = durationInSeconds / 60.0
                            self?.reloadRow(type: cellType)
            }
        default:
            return
        }
    }
    
}


extension CreateTaskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else {
            picker.dismiss(animated: true)
            
            return
        }
        
        switch mediaType {
        case String(kUTTypeImage):
            guard let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let fileData = UIImageJPEGRepresentation(originalImage.fixOrientation(), 1.0) else {
                picker.dismiss(animated: true)
                
                return
            }
            
            addAttachment(data: fileData as NSData, type: .image)
            picker.dismiss(animated: true)
        case String(kUTTypeMovie):
            guard let videoURL = info[UIImagePickerControllerMediaURL] as? URL,
                let videoData = NSData(contentsOf: videoURL)  else {
                picker.dismiss(animated: true)
                
                return
            }
            
            
            addAttachment(data: videoData, type: .video)
            picker.dismiss(animated: true)
        default:
            picker.dismiss(animated: true)
        }
    }
    
}


