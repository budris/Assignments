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

}

extension Priority: Desrciable {
    public var descriptionField: String {
        return "\(priority)"
    }
}
