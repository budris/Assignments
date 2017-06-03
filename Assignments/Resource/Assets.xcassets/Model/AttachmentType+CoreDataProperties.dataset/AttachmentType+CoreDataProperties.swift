//
//  AttachmentType+CoreDataProperties.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation
import CoreData
import UIKit


extension AttachmentType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AttachmentType> {
        return NSFetchRequest<AttachmentType>(entityName: "AttachmentType");
    }

    @NSManaged public var attachmentType: Int16
    @NSManaged public var type: Attachment?
    
    var typeEnum: AttachmentEnum {
        get { return AttachmentEnum(rawValue: Int(attachmentType)) ?? .image }
        set { attachmentType = Int16(newValue.rawValue) }
    }

}

public enum AttachmentEnum: Int {
    
    case image = 0
    case video
    
    var image: UIImage? {
        switch self {
        case .image:
            return UIImage(named: "picture")
        case .video:
            return UIImage(named: "video") 
        }
    }
    
}
