//
//  SelectColorTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class SelectColorTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(SelectColorTableViewCell.self)"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedColorView: UIView!
    
    public var title:String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    public var color: UIColor? {
        didSet {
            if let color = color {
                selectedColorView.backgroundColor = color
                selectedColorView.isHidden = false
            } else {
                selectedColorView.isHidden = true
            }
        }
    }
}
