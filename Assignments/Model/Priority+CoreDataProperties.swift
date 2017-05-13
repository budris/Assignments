//
//  Priority+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData

extension Priority {

    @NSManaged public var priority: Int16
    @NSManaged public var task: Task?
    
    var prioprityEnum: PriorityEnum {
        get { return PriorityEnum(rawValue: Int(priority)) ?? .medium }
        set { priority = Int16(newValue.rawValue) }
    }

}

public enum PriorityEnum: Int {
    case high = 0
    case medium
    case low
    
    var description: String {
        switch self {
        case .high:
            return "high"
        case .medium:
            return "medium"
        case .low:
            return "low"
        }
    }
    
    var color: UIColor {
        switch self {
        case .high:
            return UIColor(red: 230/255.0, green: 9/255.0, blue: 9/255.0, alpha: 1.0)
        case .medium:
            return UIColor(red: 242/255.0, green: 227/255.0, blue: 15/255.0, alpha: 1.0)
        case .low:
            return UIColor(red: 21/255.0, green: 252/255.0, blue: 13/255.0, alpha: 1.0)
        }
    }
    
    static let allValues: [PriorityEnum] = [.high, .medium, .low]
}

extension PriorityEnum: Selectable {
    
    public var idField: Int {
        return rawValue
    }
    
    public var descriptionField: String {
        return description
    }
}
