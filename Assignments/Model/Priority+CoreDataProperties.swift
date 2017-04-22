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
    
    var descrition: String {
        switch self {
        case .high:
            return "high"
        case .medium:
            return "medium"
        case .low:
            return "low"
        }
    }
    
    static let allValues: [PriorityEnum] = [.high, .medium, .low]
}


extension PriorityEnum: Selectable {
    
    public var id: Int {
        return rawValue
    }
    
    public var descriptionField: String {
        return descrition
    }
}
