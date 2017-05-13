//
//  ContentTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ContentTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "\(ContentTableViewCell.self)"
    
    @IBOutlet weak var contentTextView: KMPlaceholderTextView!
    public var didContentChanged: ((_ content: String?) -> ())?
    
    public var content: String? {
        get {
            return contentTextView.text
        }
        set {
            contentTextView.text = newValue
        }
    }
    
    public var placeholder: String {
        get { return contentTextView.placeholder }
        set { contentTextView.placeholder = newValue }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.delegate = self
    }
    
}

extension ContentTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        didContentChanged?(textView.text)
    }
    
}
