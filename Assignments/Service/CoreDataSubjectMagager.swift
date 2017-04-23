//
//  CoreDataSubjectMagager.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSubjectManager: NSObject {
    
    static let sharedInstance = CoreDataSubjectManager()
    
    fileprivate var coreDataSubjects: [Subject]
    
    private var fetchRequest: NSFetchRequest<NSFetchRequestResult> = {
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Subject")
        
        return fetchRequest
    }()

    
    private override init() {
        coreDataSubjects = []
        
        super.init()
        
        do {
            coreDataSubjects = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest) as? [Subject]
                ?? []
        } catch {
            print(error)
        }
        
        
    }
    
}

extension CoreDataSubjectManager: SubjectService {
    
    var subjects: [Subject] {
        return coreDataSubjects
    }
    
    func createSubject(name: String, color: UIColor?) -> Subject {
        let subject = Subject()
        
        subject.name = name
        subject.subjectColor = color
        
        CoreDataManager.instance.saveContext()
        coreDataSubjects.append(subject)
        
        return subject
    }
    
    func updateSubject(subject: Subject) {
        guard let index = coreDataSubjects.index(where: { $0.id == subject.id }) else {
            return
        }
        
        coreDataSubjects[index] = subject
        CoreDataManager.instance.saveContext()
    }
    
    func deleteSubject(subject: Subject) {
        guard let index = coreDataSubjects.index(where: { $0.id == subject.id }) else {
            return
        }
        coreDataSubjects.remove(at: index)
        
        CoreDataManager.instance.managedObjectContext.delete(subject)
        CoreDataManager.instance.saveContext()
    }
    
}
