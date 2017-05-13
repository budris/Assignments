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
    
    static let sharedInstance = CoreDataTasksManager()
        
    fileprivate var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        return fetchRequest
    }()
    
    fileprivate var coreDataTasks: [Task]
    
    private override init() {
        coreDataTasks = []
        
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
        task.id = (coreDataTasks
            .map({ return $0.id })
            .max(by: { $0 < $1 }) ?? 0) + 1
        task.title = taskPrototype.title
        task.dateCreation = Date() as NSDate?
        task.content = taskPrototype.content
        
        if let duration = taskPrototype.durationInMinutes {
            task.durationInMinutes = duration
        }
        
        task.startDate = taskPrototype.startDate
        
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
        
        if let duration = taskPrototype.durationInMinutes {
            task.durationInMinutes = duration
        }
        
        task.startDate = taskPrototype.startDate
        task.priority?.prioprityEnum = taskPrototype.priority
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
