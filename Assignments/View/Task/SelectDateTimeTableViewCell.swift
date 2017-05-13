//
//  DateTimeTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class SelectDateTimeTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(SelectDateTimeTableViewCell.self)"

    @IBOutlet weak var titleLabel: UILabel!
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
}
