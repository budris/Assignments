//
//  SelectFieldViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/18/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

protocol Selectable {
    var id: Int { get }
    var descriptionField: String { get }
}

class SelectFieldViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    public var selectionFields: [Selectable]?
    public var selectedFields: [Selectable] = []
    public var multiselectionEnabled: Bool = false
    public var onDismissCallback: ((_ selectedFields: [Selectable]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        onDismissCallback?(selectedFields)
    }
    
    fileprivate func isFieldSelected(_ field: Selectable) -> Bool {
        return selectedFields.contains(where: { $0.id == field.id })
    }
    
    fileprivate func deselectCells(for tableView: UITableView) {
        selectedFields.removeAll()
        let indexPaths = selectionFields?.enumerated().map({ IndexPath(row: $0.offset, section: 0) })
        indexPaths?.forEach({ tableView.cellForRow(at: $0)?.accessoryType = .none })
    }
    
}

extension SelectFieldViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectionFields?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectFieldTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? SelectFieldTableViewCell,
            let selectionField = selectionFields?[indexPath.row] else {
                return UITableViewCell()
        }
        
        cell.fieldLabel.text = selectionField.descriptionField
        cell.accessoryType = isFieldSelected(selectionField) ? .checkmark : .none
        
        return cell
    }
    
}

extension SelectFieldViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let selectionField = selectionFields?[indexPath.row] else {
            return
        }
        
        if !multiselectionEnabled {
            deselectCells(for: tableView)
        }
        
        let isSelected = cell.accessoryType == .checkmark
        cell.accessoryType = isSelected ? .none : .checkmark
        
        if isSelected,
            let selectedFieldIndex = selectedFields.index(where: { $0.id == selectionField.id }) {
            selectedFields.remove(at: selectedFieldIndex)
        } else {
            selectedFields.append(selectionField)
        }
    }
    
}
