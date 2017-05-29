//
//  ExportToGoogleCalendarViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 5/27/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn

class ExportToGoogleCalendarViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var exportTaskButton: UIButton!
    
    var taskForExport: Task!
    
    private let scopes = [kGTLRAuthScopeCalendar]

    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().clientID = "236844990219-823cei0bo6ivgq63mm9qm3svao8fo6li.apps.googleusercontent.com"

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        signInButton.center = view.center
        
        exportTaskButton.isHidden = true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showMessage(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            exportTaskButton.isHidden = false
            self.service.authorizer = user.authentication.fetcherAuthorizer()
        }
    }
    
    @IBAction func exportToGoogleCalendarAction(_ sender: Any) {
        let event = GTLRCalendar_Event()
        event.descriptionProperty = taskForExport.content
        event.summary = taskForExport.title
        if let startDate = taskForExport.startDate as Date? {
            let startTime = GTLRCalendar_EventDateTime()
            startTime.dateTime = GTLRDateTime(date: startDate)
            startTime.timeZone = TimeZone.current.identifier
            
            let endTime = GTLRCalendar_EventDateTime()
            endTime.dateTime = GTLRDateTime(date: startDate.addingTimeInterval(taskForExport.durationInMinutes * 60))
            endTime.timeZone = TimeZone.current.identifier
            
            event.start = startTime
            event.end = endTime
        }
        
        let query = GTLRCalendarQuery_EventsInsert.query(withObject: event,
                                                         calendarId: "primary")
        service.executeQuery(query) { [weak self] (ticket, _, error) in
            if let error = error {
                self?.showError(with: error.localizedDescription)
            } else {
                self?.showMessage(title: "Task Export", message: "Task Export succefully")
            }
        }
        
    }
    
}
