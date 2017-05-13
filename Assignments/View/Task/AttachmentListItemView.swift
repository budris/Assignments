import UIKit

class AttachmentListItemView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    class func instanceFromNib() -> AttachmentListItemView {
        return UINib(nibName: "AttachmentListItemView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AttachmentListItemView
    }

    public var image: UIImage? {
        get { return iconImageView.image }
        set { iconImageView.image = newValue }
    }
    
    public var attachmentName: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

}
