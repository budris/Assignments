
//
//  SelectDurationTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 5/8/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

import UIKit

class SelectDurationTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var durationPicker: UIDatePicker!
    
    static let reuseIdentifier: String = "\(SelectDurationTableViewCell.self)"
    
    public var duration: TimeInterval {
        get { return durationPicker.countDownDuration / 60.0 }
        set { durationPicker.countDownDuration = newValue }
    }
    
    public var didDurationChanged: ((_ duration: TimeInterval) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        durationPicker.addTarget(self,
                                 action: #selector(SelectDurationTableViewCell.durationChanged),
                                 for: .valueChanged)
    }
    
    func durationChanged(sender: UIDatePicker) {
        didDurationChanged?(sender.countDownDuration / 60.0)
    }
    
}
