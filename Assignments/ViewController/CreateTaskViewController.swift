//
//  CreateTaskViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 4/15/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createAction(_ sender: Any) {
        let task = Task()
        task.title = titleTextField.text ?? "title"
        task.dateCreation = Date() as NSDate?
        CoreDataManager.instance.saveContext()
        
        dismiss(animated: true)
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }

}
