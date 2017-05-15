//
//  EventTableViewCell.swift
//  Assignments
//
//  Created by Sak, Andrey2 on 3/21/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(TaskTableViewCell.self)"

    @IBOutlet private(set) weak var timeLabel: UILabel!
    @IBOutlet private(set) weak var subjectLabel: UILabel!
    @IBOutlet private(set) weak var separatorView: UIView!
    
    public var timeValue: String? {
        get { return timeLabel.text }
        set { timeLabel.text = newValue }
    }
    
    public var titleValue: String? {
        get { return subjectLabel.text }
        set { subjectLabel.text = newValue }
    }
    
    public var status: StatusEnum? {
        didSet {
            if let status = status {
                separatorView.backgroundColor = status.color
            }
        }
    }
    
}
