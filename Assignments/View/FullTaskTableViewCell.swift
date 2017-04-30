//
//  FullTaskTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class FullTaskTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(FullTaskTableViewCell.self)"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var priorityLabel: UILabel!
    @IBOutlet private weak var additionalInfoStackView: UIStackView!
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var status: StatusEnum? {
        didSet {
            statusLabel.text = status?.description
        }
    }
    
    public var priority: PriorityEnum? {
        didSet {
            priorityLabel.text = priority?.description
        }
    }    

}
