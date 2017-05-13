//
//  Task+CoreDataClass.swift
//  Assignments
//
//  Created by Andrey Sak on 5/8/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


public class Task: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityFor(name: "\(Task.self)"),
                  insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
