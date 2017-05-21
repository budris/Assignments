//
//  TitleTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/16/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(TitleTableViewCell.self)"

    @IBOutlet private weak var titleTextField: UITextField!
    
    public var didChangeTitle: ((_ title: String?) -> ())?
    
    public var value: String? {
        get { return titleTextField.text }
        set { titleTextField.text = newValue }
    }
    
    public var placeholder: String? {
        get { return titleTextField.placeholder }
        set { titleTextField.placeholder = newValue }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = true
        titleTextField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            titleTextField.becomeFirstResponder()
        }
    }

}

extension TitleTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didChangeTitle?(textField.text)
    }
    
}
