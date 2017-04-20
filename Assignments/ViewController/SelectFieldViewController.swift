//
//  SelectFieldViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/18/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

protocol Desrciable {
    var descriptionField: String { get }
}

class SelectFieldViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    public var selectionFields: [Desrciable]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

extension SelectFieldViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionFields?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectFieldTableViewCell.reuseIdentifier, for: indexPath) as? SelectFieldTableViewCell,
            let selectionField = selectionFields?[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.fieldLabel.text = selectionField.descriptionField
        
        return UITableViewCell()
    }
}

extension SelectFieldViewController: UITableViewDelegate {
}
