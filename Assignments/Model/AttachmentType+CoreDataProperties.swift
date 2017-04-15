//
//  AttachmentType+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


extension AttachmentType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttachmentType> {
        return NSFetchRequest<AttachmentType>(entityName: "AttachmentType");
    }

    @NSManaged public var attachmentType: Int16
    @NSManaged public var type: Attachment?

}
