//
//  StatisticsViewController.swift
//  Assignments
//
//  Created by Sak, Andrey2 on 3/21/17.
//  Copyright © 2017 Andrey Sak. All rights reserved.
//

import UIKit
import Charts

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    typealias StudyData = (value: Double, label: String)
    let dataSource = [StudyData(value: 30.21, label: "Done"),
                      StudyData(value: 20.49, label: "In progress"),
                      StudyData(value: 25.12, label: "To Do"),
                      StudyData(value: 25.18, label: "To be discuss")]

    override func viewDidLoad() {
        super.viewDidLoad()

        pieChartView.delegate = self
        setChartData()

    }

    private func setChartData() {
        let values: [PieChartDataEntry] = dataSource.map({ PieChartDataEntry(value: $0, label: $1) })
        let dataSet = PieChartDataSet(values: values, label: "Tasks Statistics")

        dataSet.drawValuesEnabled = true
        dataSet.sliceSpace = 2.0

        // add a lot of colors

        var colors: [UIColor] = []
        colors.append(contentsOf: ChartColorTemplates.colorful())

        dataSet.colors = colors

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
//        pieChartView.highlighted = nil
    }
}

extension StatisticsViewController: ChartViewDelegate {
    
}
