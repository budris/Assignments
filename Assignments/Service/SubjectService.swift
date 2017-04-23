//
//  SubjectService.swift
//  Assignments
//
//  Created by Andrey Sak on 4/23/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import Foundation

protocol SubjectService {
    
    var subjects: [Subject] { get }
    
    func createSubject(name: String, color: UIColor?) -> Subject
    func updateSubject(subject: Subject)
    func deleteSubject(subject: Subject)
    
}
