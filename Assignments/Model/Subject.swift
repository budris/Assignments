//
//  Subject+CoreDataClass.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


public class Subject: NSManagedObject {    
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityFor(name: "\(Subject.self)"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
