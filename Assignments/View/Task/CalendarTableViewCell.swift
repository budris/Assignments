//
//  CalendarTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 5/25/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(CalendarTableViewCell.self)"
    
    @IBOutlet weak var nameLabel: UILabel!
    
    public var name: String? {
        get { return nameLabel.text }
        set { nameLabel.text = newValue }
    }
}
