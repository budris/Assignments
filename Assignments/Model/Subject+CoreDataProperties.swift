//
//  Subject+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject");
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var color: NSData?
    @NSManaged public var task: Task?

}
