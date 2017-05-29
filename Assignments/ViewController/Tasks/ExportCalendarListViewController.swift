//
//  ExportCalendarListViewController.swift
//  Assignments
//
//  Created by Andrey Sak on 5/25/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import EventKit

extension Notification.Name {
    static let exportToGoogleGalenarNotificationName = Notification.Name("EXPORT_TO_GOOGLE_CALENDAR")
}

class ExportCalendarListViewController: UIViewController {
    
    @IBOutlet weak var calendarsTableView: UITableView!

    var taskForExport: Task!
    
    var iCalendars = [EKCalendar]()
    let eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarsTableView.dataSource = self
        calendarsTableView.delegate = self
        
        getICalendars()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.toGoogleCalendar,
            let exportToGoogleCalendarVC = segue.destination as? ExportToGoogleCalendarViewController {
            exportToGoogleCalendarVC.taskForExport = taskForExport
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func getICalendars() {
        eventStore.requestAccess(to: .event) { [weak self] accessIsGranted, error in
            guard let strongSelf = self else {
                return
            }
            
            if !accessIsGranted {
                self?.showError(with: "This app does not have access to your calendar. You can enable access in Privacy Settings.")
            }
            
            strongSelf.iCalendars = strongSelf.eventStore.calendars(for: .event).filter({ $0.allowsContentModifications == true })
            DispatchQueue.main.async {
                self?.calendarsTableView.reloadData()
            }
        }
    }
    
    fileprivate func createICalendarEvent(calendar: EKCalendar) {
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.calendar = calendar
        newEvent.title = taskForExport.title ?? ""
        newEvent.location = taskForExport.content
        if let startDate = taskForExport.startDate as Date? {
            
            newEvent.startDate = startDate
            newEvent.endDate = startDate.addingTimeInterval(taskForExport.durationInMinutes * 60.0)
            newEvent.alarms = [EKAlarm(absoluteDate: startDate)]
        }
        newEvent.notes = taskForExport.content
        
//        if let recurrence = event.recurrence, recurrence.type != .none {
//            var rule: EKRecurrenceRule
//            var frequency: EKRecurrenceFrequency
//            
//            switch recurrence.type {
//            case .daily:
//                frequency = .daily
//            case .weekly:
//                frequency = .weekly
//            case .monthly:
//                frequency = .monthly
//            case .yearly:
//                frequency = .yearly
//            default:
//                // Should be never execute
//                frequency = .daily
//            }
//            
//            if let endDate = recurrence.endDate {
//                rule = EKRecurrenceRule(recurrenceWith: frequency, interval: 1, end: EKRecurrenceEnd(end: endDate))
//            } else {
//                rule = EKRecurrenceRule(recurrenceWith: frequency, interval: 1, end: EKRecurrenceEnd(occurrenceCount: recurrence.count))
//            }
//            
//            newEvent.recurrenceRules = [rule]
//        }
        
        var alarmDate: Date?
//        let startDate = event.startDate
//        
//        switch event.reminder {
//        case .fiveMinutes:
//            alarmDate = startDate.subtract(TimeChunk(minutes: 5))
//        case .thirtyMinutes:
//            alarmDate = startDate.subtract(TimeChunk(minutes: 30))
//        case .oneHour:
//            alarmDate = startDate.subtract(TimeChunk(hours: 1))
//        case .twoHours:
//            alarmDate = startDate.subtract(TimeChunk(hours: 2))
//        case .fourHours:
//            alarmDate = startDate.subtract(TimeChunk(hours: 4))
//        case .eightHours:
//            alarmDate = startDate.subtract(TimeChunk(hours: 8))
//        case .oneDay:
//            alarmDate = startDate.subtract(TimeChunk(days: 1))
//        case .oneWeek:
//            alarmDate = startDate.subtract(TimeChunk(weeks: 1))
//        case .oneMonth:
//            alarmDate = startDate.subtract(TimeChunk(months: 1))
//        default:
//            break
//        }
        
        do {
            try eventStore.save(newEvent, span: .thisEvent)
            showMessage(title: "Export task", message: "The task was successfully exported")
        } catch let error {
            showError(with: "Event could not save: \(error.localizedDescription)")
        }
    }
    
}

extension ExportCalendarListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iCalendars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.reuseIdentifier, for: indexPath) as? CalendarTableViewCell else {
            return UITableViewCell()
        }
        
        let calendar = iCalendars[indexPath.row]
        cell.name = calendar.title
        
        return cell
    }
}

extension ExportCalendarListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let calendar = iCalendars[indexPath.row]
        createICalendarEvent(calendar: calendar)
    }
}
