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
    
    var dataSource: [StudyData] = []
    fileprivate var tasksForStatus: [Task] = []
    
    private var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        pieChartView.delegate = self
        
        tasksTableView.dataSource = self
//        tasksTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupDataSource()
    }
    
    private func setupDataSource() {
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
        
        dataSource = statusesOfTasks.map({ (key: String, value: Int) -> StudyData in
            StudyData(value:  Double(value) / Double(countOfTaskWithStatus) * 100.0, label: key)
        })
        
        setChartData()
    }

    private func setChartData() {
        let values: [PieChartDataEntry] = dataSource.map({ PieChartDataEntry(value: $0, label: $1) })
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
            let taskDate = tasksForStatus[indexPath.row].startDate as? Date else {
                return UITableViewCell()
        }
        
        cell.timeLabel.text = taskDate.formattedTimeDescription()
        cell.subjectLabel.text = tasksForStatus[indexPath.row].title
        
        return cell
    }
    
}
