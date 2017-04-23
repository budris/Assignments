//
//  SelectDateTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class SelectDateTableViewCell: UITableViewCell {
    private static let dateFormat: String = "h ma dd/mm/yy"
    
    static let reuseIdentifier: String = "\(SelectDateTableViewCell.self)"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    public var value: Date? {
        didSet {
            if let value = value {
                dateLabel.text = dateFormatter.string(from: value)
            } else {
                dateLabel.text = "None"
            }
            
        }
    }
    
    private let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter.dateFormat = SelectDateTableViewCell.dateFormat
    }

}
