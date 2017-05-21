//
//  ShortcutContainer.swift
//  Assignments
//
//  Created by Andrey Sak on 5/21/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

class ShortcutContainer {
    
    static let sharedInstance = ShortcutContainer()
    
    private var selectedAction: ShortcutAction?
    
    private init() {
        selectedAction = nil
    }
    
    func setSelectedAction(_ newValue: ShortcutAction) {
        selectedAction = newValue
    }
    
    func getSelectedAction() -> ShortcutAction? {
        let action = selectedAction
        selectedAction = nil
        
        return action
    }
    
}
