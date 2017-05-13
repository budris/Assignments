//
//  Date.swift
//  Assignments
//
//  Created by Andrey Sak on 5/6/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

extension Date {
    
    func formattedDateDescription() -> String {
        let dateFormat = "EEEE MMM d, yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.string(from: self)
    }
    
    func formattedTimeDescription() -> String {
        let timeFormat = "HH:mm"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "\(timeFormat)"
        
        return dateFormatter.string(from: self)
    }
    
}
