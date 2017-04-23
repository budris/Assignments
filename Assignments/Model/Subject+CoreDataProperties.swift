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
    
    var subjectColor: UIColor? {
        get {
            guard let color = color as Data? else {
                return nil
            }
            
            return UIColor.color(withData: color)
        }
        set {
            guard let newColor = newValue else {
                return
            }
            
            color = newColor.encode() as NSData
        }
    }

}

extension Subject: Selectable {
    
    public var idField: Int {
        return Int(id)
    }
    
    public var descriptionField: String {
        return name ?? ""
    }
}
