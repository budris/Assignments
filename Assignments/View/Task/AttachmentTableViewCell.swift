//
//  AttachmentTableViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 5/13/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class AttachmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attachmentsStackView: UIStackView!
    
    private func setupAttachments(attachments: [Attachment]) {
        for view in attachmentsStackView.subviews {
            view.removeFromSuperview()
        }
        for attachment in attachments {
            let attachmentsView = AttachmentListItemView.instanceFromNib()
            
            attachmentsView.attachmentName = attachment.name
            attachmentsView.image = attachment.type?.typeEnum.image
            
            attachmentsView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            attachmentsStackView.addArrangedSubview(attachmentsView)
        }
    }
}
