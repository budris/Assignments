//
//  CollorCollectionViewCell.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    private static let selectedAnimationDuration: TimeInterval = 0.3
    
    static let reuseIdentifier: String = "\(ColorCollectionViewCell.self)"
    
    @IBOutlet weak var selectedColorView: UIView!
    
    public var color: UIColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    public var isSelectedColor: Bool = false {
        didSet {
            UIView.animate(withDuration: ColorCollectionViewCell.selectedAnimationDuration,
                           delay: 0.0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.8,
                           options: UIViewAnimationOptions.curveEaseOut,
                           animations: { [weak self] in
                            guard let strongSelf = self else {
                                return
                            }
                            strongSelf.selectedColorView.isHidden = !strongSelf.isSelectedColor
                            
            })
        }
    }
    
    
}
