//
//  SelectionTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(SelectionTableViewCell.self)"
    
    var taskField: TaskField?
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var valueLabel: UILabel!

}

extension SelectionTableViewCell {
    
    func setup(with taskField: TaskField, taskPrototype: TaskPrototype) {
        titleLabel.text = taskField.description
        
        var valueText: String?
        switch taskField {
        case .subject:
            valueText = taskPrototype.subject?.name
        case .priority:
            valueText = taskPrototype.priority.descriptionField
        case .status:
//            valueText = task.status?.status ?? ""
            valueText = "status"
        default:
            valueText = nil
        }
        valueLabel.text = valueText
    }
    
}
