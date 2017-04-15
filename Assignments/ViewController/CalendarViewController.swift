//
//  CalendarViewController.swift
//  Assignments
//
//  Created by Sak, Andrey2 on 3/21/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var tasksTableView: UITableView!

    fileprivate typealias Event = (time: String, subject: String)

    fileprivate let dataSource = [Event("11:30","Read Andrew Tanenbaun"), Event("15:30","The write a beautiful code")]
    fileprivate let datesWithEvents = [11, 22, 31]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.dataSource = self
        calendarView.dataSource = self
    }

}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as? TaskTableViewCell else {
            return UITableViewCell()
        }

        cell.timeLabel.text = dataSource[indexPath.row].time
        cell.subjectLabel.text = dataSource[indexPath.row].subject

        return cell
    }
}

extension CalendarViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let componetns: Set<Calendar.Component> = [.day]
        let dateComponents = Calendar.current.dateComponents(componetns, from: date)

        if let index = datesWithEvents.index(of: dateComponents.day ?? 0) {
            return datesWithEvents[index] % 10
        } else {
            return 0
        }
    }

}
