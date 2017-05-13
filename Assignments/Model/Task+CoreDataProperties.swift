//
//  Task+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 5/8/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var content: String?
    @NSManaged public var dateCreation: NSDate?
    @NSManaged public var durationInMinutes: Double
    @NSManaged public var id: Int32
    @NSManaged public var startDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var attachments: NSSet?
    @NSManaged public var priority: Priority?
    @NSManaged public var status: Status?

}

// MARK: Generated accessors for attachments
extension Task {

    @objc(addAttachmentsObject:)
    @NSManaged public func addToAttachments(_ value: Attachment)

    @objc(removeAttachmentsObject:)
    @NSManaged public func removeFromAttachments(_ value: Attachment)

    @objc(addAttachments:)
    @NSManaged public func addToAttachments(_ values: NSSet)

    @objc(removeAttachments:)
    @NSManaged public func removeFromAttachments(_ values: NSSet)

}
