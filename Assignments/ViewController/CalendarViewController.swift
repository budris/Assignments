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
    
    // MARK : Services
    
    fileprivate let tasksService: TaskService = CoreDataTasksManager.sharedInstance
    
    fileprivate var calendarDataSource: [String : [Task]] = [:]
    fileprivate var tasksForDate: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        generateCalendarDataSource()
        generateTasksDataSource(for: calendarView.selectedDate ?? Date())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.editTask {
            guard let navVC = segue.destination as? UINavigationController,
                let editTaskVC = navVC.topViewController as? CreateTaskViewController,
                let task = sender as? Task else {
                    return
            }
            
            editTaskVC.editedTask = task
            editTaskVC.didUpdatedTask = { [weak self] task in
                guard let index = self?.tasksForDate.index(where: { $0.id == task.id }) else {
                    return
                }
                
                self?.tasksTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func generateCalendarDataSource() {
        calendarDataSource.removeAll()
        tasksService.tasks.forEach { task in
            guard let taskDate = task.startDate as Date? else {
                return
            }
            
            if var tasksForThisDate = calendarDataSource[taskDate.formattedDateDescription()] {
                tasksForThisDate.append(task)
                calendarDataSource[taskDate.formattedDateDescription()] = tasksForThisDate
            } else {
                calendarDataSource[taskDate.formattedDateDescription()] = [task]
            }
        }
        calendarView.reloadData()
        
        let currentDate = Date()
        generateTasksDataSource(for: currentDate)
    }
    
    fileprivate func generateTasksDataSource(for date: Date) {
        tasksForDate.removeAll()
        tasksForDate = calendarDataSource[date.formattedDateDescription()] ?? []
        tasksTableView.reloadData()
    }

}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksForDate.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as? TaskTableViewCell,
            let taskDate = tasksForDate[indexPath.row].startDate as Date? else {
            return UITableViewCell()
        }

        let task = tasksForDate[indexPath.row]
        cell.timeValue = taskDate.formattedTimeDescription()
        cell.titleValue = task.title
        cell.status = task.status?.statusEnum
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasksForDate[indexPath.row]
        performSegue(withIdentifier: SegueIdentifier.editTask, sender: task)
    }
}

extension CalendarViewController: FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return calendarDataSource[date.formattedDateDescription()]?.count ?? 0
    }

}

extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        generateTasksDataSource(for: date)
    }
    
}
