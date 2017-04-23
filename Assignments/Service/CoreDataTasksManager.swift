//
//  TaskService.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataTasksManager: NSObject, TaskService {
    
    static let instance = CoreDataTasksManager()
    
    var tasks: [Task] {
        return coreDataTasks
    }
    
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
        
        
//        fetchedResultsController.delegate = self 
        
        do {
            coreDataTasks = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [Task]
                ?? []
        } catch {
            print(error)
        }
    }
    
    func createTask(title: String) -> Task {
        let task = Task()
        task.title = title
        task.dateCreation = Date() as NSDate?
        coreDataTasks.append(task)
        task.priority?.prioprityEnum = PriorityEnum.medium
        
        CoreDataManager.instance.saveContext()
        
        return task
    }
    
    func updateTask(task: Task) {
        guard let index = coreDataTasks.index(where: { $0.id == task.id }) else {
            return
        }
        coreDataTasks[index] = task
        
//        CoreDataManager.instance.managedObjectContext.update(task)
        
        CoreDataManager.instance.saveContext()
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
