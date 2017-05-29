//
//  StatisticsViewController.swift
//  Assignments
//
//  Created by Sak, Andrey2 on 3/21/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    fileprivate let tasksService: TaskService = CoreDataTasksManager.sharedInstance
    
    typealias StudyData = (value: Double, label: String)
    
    fileprivate var statisticDataSource: [StudyData] = []
    fileprivate var tasksForStatus: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        pieChartView.delegate = self
        
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        generateStatisticsDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask" {
            guard let navVC = segue.destination as? UINavigationController,
                let editTaskVC = navVC.topViewController as? CreateTaskViewController,
                let task = sender as? Task else {
                    return
            }
            
            editTaskVC.editedTask = task
            editTaskVC.didUpdatedTask = { [weak self] task in
                guard let index = self?.tasksForStatus.index(where: { $0.id == task.id }) else {
                    return
                }
                
                self?.tasksTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func generateStatisticsDataSource() {
        let tasks = tasksService.tasks
        
        var statusesOfTasks: [String : Int] = [:]
        var countOfTaskWithStatus = 0
        
        tasks.forEach { task in
            guard let status = task.status?.statusEnum.descriptionField else {
                return
            }
            countOfTaskWithStatus += 1
            
            if statusesOfTasks.keys.contains(status) {
                let currentCount = statusesOfTasks[status] ?? 0
                statusesOfTasks[status] = currentCount + 1
            } else {
                statusesOfTasks[status] = 1
            }
        }
        
        statisticDataSource = statusesOfTasks.map({ (key: String, value: Int) -> StudyData in
            StudyData(value:  Double(value) / Double(countOfTaskWithStatus) * 100.0, label: key)
        })
        
        setChartData()
    }

    private func setChartData() {
        let values: [PieChartDataEntry] = statisticDataSource.map({ PieChartDataEntry(value: $0, label: $1) })
        let dataSet = PieChartDataSet(values: values, label: "Tasks Statistics")

        dataSet.drawValuesEnabled = true
        dataSet.sliceSpace = 2.0

        // add a lot of colors

        dataSet.colors = ChartColorTemplates.colorful()

        let data = PieChartData(dataSet: dataSet)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = NSNumber(floatLiteral: 1.0)
        pFormatter.percentSymbol = " %"

        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 14))
        data.setValueTextColor(NSUIColor.darkText)

        pieChartView.data = data;
    }
}

extension StatisticViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let entryLabel = (entry as? PieChartDataEntry)?.label,
            let selectedStatus = StatusEnum.status(by: entryLabel) else {
            return
        }
        
        tasksForStatus = tasksService.tasks.filter({ $0.status?.statusEnum == selectedStatus })
        tasksTableView.reloadData()
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        tasksForStatus = []
        tasksTableView.reloadData()
    }
}


extension StatisticViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksForStatus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as? TaskTableViewCell,
            let taskDate = tasksForStatus[indexPath.row].startDate as Date? else {
                return UITableViewCell()
        }
        
        let task = tasksForStatus[indexPath.row]
        cell.timeValue = taskDate.formattedTimeDescription()
        cell.titleValue = task.title
        cell.status = task.status?.statusEnum
        
        return cell
    }
    
}

extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = tasksForStatus[indexPath.row]
        performSegue(withIdentifier: "editTask", sender: task)
    }
}
