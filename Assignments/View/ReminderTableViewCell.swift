//
//  ReminderTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 5/11/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(ReminderTableViewCell.self)"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    public var titleValue: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var timeValue: String? {
        get { return timeLabel.text }
        set { timeLabel.text = newValue }
    }
    
}
