//
//  Status+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    var color: UIColor {
        switch self {
        case .complete:
            return UIColor(red: 36/255.0, green: 189/255.0, blue: 38/255.0, alpha: 1.0)
        case .inProgress:
            return UIColor(red: 61/255.0, green: 150/255.0, blue: 227/255.0, alpha: 1.0)
        case .postponed:
            return UIColor(red: 176/255.0, green: 2/255.0, blue: 245/255.0, alpha: 1.0)
        case .toDo:
            return UIColor(red: 247/255.0, green: 88/255.0, blue: 20/255.0, alpha: 1.0)
        }
    }
    
    static func status(by description: String) -> StatusEnum? {
        var status: StatusEnum?
        switch description {
        case "complete":
            status = .complete
        case "in progress":
            status = .inProgress
        case "postponed":
            status = .postponed
        case "to do":
            status = .toDo
        default:
            status = nil
        }
        return status
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
