//
//  SelectColorViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class SelectColorViewController: UIViewController {
    fileprivate static let selectionColors: [UIColor] = [UIColor.black,
                                                     UIColor.blue,
                                                     UIColor.green,
                                                     UIColor.yellow,
                                                     UIColor.purple]
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    
    public var selectedColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorsCollectionView.dataSource = self
        colorsCollectionView.delegate = self
    }
    
}

extension SelectColorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SelectColorViewController.selectionColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ColorCollectionViewCell else {
                                                                return UICollectionViewCell()
        }
        
        let cellColor = SelectColorViewController.selectionColors[indexPath.row]
        cell.color = cellColor
        cell.isSelectedColor = (cellColor == selectedColor)
        
        return cell
    }
    
}

extension SelectColorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else {
            return
        }
        
        cell.isSelectedColor = !cell.isSelectedColor
        
        if cell.isSelected {
            selectedColor = cell.color
        } else {
            guard let selectedColor = selectedColor,
                let index = SelectColorViewController.selectionColors.index(of: selectedColor),
                let cell = collectionView.cellForItem(at: IndexPath(row: index,
                                                                    section: 0)) as? ColorCollectionViewCell else {
                    return
            }
            
            cell.isSelectedColor = false
        }
    }
    
}
