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
            if let status = status {
                statusLabel.text = status.description
                statusLabel.textColor = status.color
            }
        }
    }
    
    public var priority: PriorityEnum? {
        didSet {
            if let priority = priority {
                priorityLabel.text = priority.description
                priorityLabel.textColor = priority.color
            }
        }
    }
    
    public var attachments: [Attachment] = [] {
        didSet {
            setupAttachments(attachments: attachments)
        }
    }
    
    var didSelectAttachment: ((_ attachment: Attachment) -> ())?
    
    public func setupAttachments(attachments: [Attachment]) {
        for view in additionalInfoStackView.subviews {
            view.removeFromSuperview()
        }
        for attachment in attachments {
            let attachmentsView = AttachmentListItemView.instanceFromNib()
            
            attachmentsView.attachmentName = attachment.name
            attachmentsView.image = attachment.type?.typeEnum.image
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FullTaskTableViewCell.attachmentTapped(recognizer:)))
            attachmentsView.addGestureRecognizer(tapGesture)
            
            attachmentsView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            additionalInfoStackView.addArrangedSubview(attachmentsView)
        }
    }
    
    public func attachmentTapped(recognizer: UITapGestureRecognizer) {
        guard let attachmentsView = recognizer.view as? AttachmentListItemView,
            let index = additionalInfoStackView.subviews.index(of: attachmentsView) else {
            return
        }
        
        didSelectAttachment?(attachments[index])
    }

}
