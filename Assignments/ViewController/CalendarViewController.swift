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
    
    fileprivate let tasksService: TaskService = CoreDataTasksManager.sharedInstance

    fileprivate typealias Event = (time: String, subject: String)

    fileprivate var dataSource: [String : [Task]] = [:]
    fileprivate var tasksForDate: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.dataSource = self
        
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        generateDataSource()
    }
    
    private func generateDataSource() {
        dataSource.removeAll()
        tasksService.tasks.forEach { task in
            guard let taskDate = task.startDate as? Date else {
                return
            }
            
            if var tasksForThisDate = dataSource[taskDate.formattedDateDescription()] {
                tasksForThisDate.append(task)
                dataSource[taskDate.formattedDateDescription()] = tasksForThisDate
            } else {
                dataSource[taskDate.formattedDateDescription()] = [task]
            }
        }
        calendarView.reloadData()
        
        let currentDate = Date()
        filterTasks(for: currentDate)
    }
    
    fileprivate func filterTasks(for date: Date) {
        tasksForDate.removeAll()
        tasksForDate = dataSource[date.formattedDateDescription()] ?? []
        tasksTableView.reloadData()
    }
    
    fileprivate func compareDatesByDay(_ firstDate: Date, _ secondDate: Date) -> Bool {
       return true
    }

}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksForDate.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as? TaskTableViewCell,
            let taskDate = tasksForDate[indexPath.row].startDate as? Date else {
            return UITableViewCell()
        }

        cell.timeLabel.text = taskDate.formattedTimeDescription()
        cell.subjectLabel.text = tasksForDate[indexPath.row].title

        return cell
    }
}

extension CalendarViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return dataSource[date.formattedDateDescription()]?.count ?? 0
    }

}

extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        filterTasks(for: date)
    }
    
}
