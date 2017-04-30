//
//  TaskService.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataTasksManager: NSObject {
    
    static let instance = CoreDataTasksManager()
        
    private var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        return fetchRequest
    }()
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    fileprivate var coreDataTasks: [Task]
    
    private override init() {
        coreDataTasks = []
        fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Task",
                                                                                     keyForSort: "id")
        
        super.init()
        
        do {
            coreDataTasks = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [Task]
                ?? []
        } catch {
            print(error)
        }
    }
  
}

extension CoreDataTasksManager: TaskService {
    
    var tasks: [Task] {
        return coreDataTasks
    }
    
    func createTask(taskPrototype: TaskPrototype) -> Task {
        let task = Task()
        task.title = taskPrototype.title
        task.dateCreation = Date() as NSDate?
        task.content = taskPrototype.content
        task.endDate = taskPrototype.endDate
        task.startDate = taskPrototype.startDate
        task.subject = taskPrototype.subject
        let priority = Priority()
        priority.prioprityEnum = taskPrototype.priority
        task.priority = priority
        
        let status = Status()
        status.statusEnum = taskPrototype.status
        task.status = status
        
        coreDataTasks.append(task)
        CoreDataManager.instance.saveContext()
        
        return task
    }
    
    func updateTask(taskPrototype: TaskPrototype) -> Task? {
        guard let taskId = taskPrototype.id,
            let index = coreDataTasks.index(where: { $0.id == Int32(taskId) }) else {
                return nil
        }
        
        let task = coreDataTasks[index]
        task.title = taskPrototype.title
        task.dateCreation = Date() as NSDate?
        task.content = taskPrototype.content
        task.endDate = taskPrototype.endDate
        task.startDate = taskPrototype.startDate
        task.priority?.prioprityEnum = taskPrototype.priority
        task.subject = taskPrototype.subject
        task.status?.statusEnum = taskPrototype.status
        
        task.priority?.prioprityEnum = PriorityEnum.medium
        
        coreDataTasks[index] = task
        CoreDataManager.instance.saveContext()
        
        return task
    }
    
    func deleteTask(task: Task) {
        guard let index = coreDataTasks.index(where: { $0.id == task.id }) else {
            return
        }
        coreDataTasks.remove(at: index)
        
        CoreDataManager.instance.managedObjectContext.delete(task)
        CoreDataManager.instance.saveContext()
    }
    
}

//extension CoreDataTasksManager: NSFetchedResultsControllerDelegate {
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//        guard let task = anObject as? Task else {
//            return
//        }
//        
//        switch type {
//        case .insert:
//            coreDataTasks.append(task)
//        case .delete:
//            guard let index = coreDataTasks.index(where: { $0.id == task.id }) else {
//                return
//            }
//            coreDataTasks.remove(at: index)
//        case .move:
//            guard let fromIndexPath = indexPath,
//                let toIndexPath = newIndexPath else {
//                    return
//            }
//            
//            let task = coreDataTasks.remove(at: fromIndexPath.row)
//            coreDataTasks.insert(task, at: toIndexPath.row)
//        case .update:
//            guard let index = coreDataTasks.index(where: { $0.id == task.id }) else {
//                return
//            }
//            
//            coreDataTasks[index] = task
//        }
//    }
//    
//}
