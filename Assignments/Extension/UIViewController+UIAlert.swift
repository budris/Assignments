//
//  UIViewController+UIAlert.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showMessage(title: String?, message: String?) {
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        
        let messageAlert = UIAlertController(title: title,
                                           message: message,
                                           preferredStyle: .alert)
        
        messageAlert.addAction(okAction)
        
        present(messageAlert, animated: true)
    }
    
    func showError(with message: String) {
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        
        let errorAlert = UIAlertController(title: "Error",
                                           message: message,
                                           preferredStyle: .alert)
        
        errorAlert.addAction(okAction)
        
        present(errorAlert, animated: true)
    }
    
}
