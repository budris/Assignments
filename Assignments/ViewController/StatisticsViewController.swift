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
    
    fileprivate let subjectService: SubjectService = CoreDataSubjectManager.sharedInstance
    fileprivate let tasksService: TaskService = CoreDataTasksManager.sharedInstance
    
    typealias StudyData = (value: Double, label: String)
    
    var dataSource = [StudyData(value: 30.21, label: "Done"),
                      StudyData(value: 20.49, label: "In progress"),
                      StudyData(value: 25.12, label: "To Do"),
                      StudyData(value: 25.18, label: "To be discuss")]
    
    private var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        pieChartView.delegate = self
        setChartData()
        
        if subjectService.subjects.isEmpty {
            
        } else {
            setupNavigationDropdownMenu()
        }
    }
    
    func setupNavigationDropdownMenu() {
        var items = subjectService.subjects.map { $0.descriptionField }
        
        navigationController?.navigationBar.backgroundColor = UIColor.black
        
        let menuView = NavigationDropdownMenu(navigationController: navigationController, containerView: navigationController!.view, title: items[0], items: items as [AnyObject], bottomOffset: 44.0)
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont.systemFont(ofSize: 14.0)
        menuView.cellTextLabelAlignment = .center
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.exclusiveRows = [selectedIndex]
        menuView.didSelectItemAtIndexHandler = { [weak self] index in
            guard let subject = self?.subjectService.subjects[index] else {
                return
            }
            
            self?.newSubjectSelected(with: subject)
        }
        
        navigationItem.titleView = menuView
    }
    
    private func newSubjectSelected(with subject: Subject) {
        let tasks = tasksService.getTasks(filteredBy: subject)
        
        
        // TODO: - replace with Set
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
            StudyData(value:  Double(value / countOfTaskWithStatus) * 100.0, label: key)
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
    
}
