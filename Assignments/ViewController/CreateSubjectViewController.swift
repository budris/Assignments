//
//  CreateSubjectViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class CreateSubjectViewController: UIViewController {
    
    enum SubjectFiled {
        case title
        case color
    }
    
    public var subjectService: SubjectService = CoreDataSubjectManager.sharedInstance
    
    @IBOutlet weak var subjectFieldsTableView: UITableView!
    
    fileprivate var subjectFieldsDataSource: [SubjectFiled] = [.title, .color]
    
    fileprivate var name: String?
    fileprivate var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subjectFieldsTableView.delegate = self
        subjectFieldsTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectColorVC = segue.destination as? SelectColorViewController {
            selectColorVC.selectedColor = color
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func createAction(_ sender: Any) {
        let values = getValues()
        guard let name = values.name else {
            showError(with: "Name can not be empty")
            return
        }
        
        let _ = subjectService.createSubject(name: name, color: values.color)
        dismiss(animated: true)
    }
    
    private func getValues() -> (name: String?, color: UIColor?) {
        var name: String?
        var color: UIColor?
        
        let indexPaths = subjectFieldsDataSource.enumerated().map({ IndexPath(row: $0.offset, section: 0) })
        
        indexPaths.forEach { indexPath in
            guard let cell = subjectFieldsTableView.cellForRow(at: indexPath) else {
                return
            }
            
            let subjectField = subjectFieldsDataSource[indexPath.row]
            switch subjectField {
            case .title:
                guard let cell = cell as? TitleTableViewCell else {
                    return
                }
                
                name = cell.value
            case .color:
                guard let cell = cell as? SelectColorTableViewCell else {
                    return
                }
                
                color = cell.color
            }
        }
        
        return (name, color)
    }
    
}

extension CreateSubjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "selectColor", sender: self)
    }
    
}

extension CreateSubjectViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectFieldsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = subjectFieldsDataSource[indexPath.row]
        
        switch type {
        case .title:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? TitleTableViewCell else {
                                                            return UITableViewCell()
            }
            
            cell.placeholder = "Subject Title"
            cell.value = name
            
            return cell
        case .color:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectColorTableViewCell.reuseIdentifier,
                                                           for: indexPath) as? SelectColorTableViewCell else {
                                                            return UITableViewCell()
            }
            
            cell.title = "Subject Color"
            cell.color = color
            
            return cell
        }
    }
    
}
