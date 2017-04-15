//
//  Attachment+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


extension Attachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment");
    }

    @NSManaged public var name: String?
    @NSManaged public var data: NSData?
    @NSManaged public var type: AttachmentType?
    @NSManaged public var task: Task?

}
