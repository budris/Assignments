//
//  Status+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData


extension Status {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Status> {
        return NSFetchRequest<Status>(entityName: "Status");
    }

    @NSManaged public var status: Int16
    @NSManaged public var task: Task?
    
    var statusEnum: StatusEnum {
        get { return StatusEnum(rawValue: Int(status)) ?? .toDo }
        set { status = Int16(newValue.rawValue) }
    }

}

public enum StatusEnum: Int {
    
    case complete = 0
    case inProgress
    case postponed
    case toDo
    
    var description: String {
        switch self {
        case .complete:
            return "complete"
        case .inProgress:
            return "in progress"
        case .postponed:
            return "postponed"
        case .toDo:
            return "to do"
        }
    }
    
    static let allValues: [StatusEnum] = [.complete, .inProgress, .postponed, .toDo]
    
}

extension StatusEnum: Selectable {
    
    public var idField: Int {
        return rawValue
    }
    
    public var descriptionField: String {
        return description
    }
}
