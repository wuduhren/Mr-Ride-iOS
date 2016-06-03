//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/25.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import CoreData
import Charts


// MARK: - Main

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    class func controller() -> HistoryViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let runDataModel = RunDataModel()
    private var runDataStructArray: [RunDataModel.runDataStruct] = []
    
    private var runDataSortedByTime: [String: [RunDataModel.runDataStruct]] = [:]
    private var headers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        prepareTableViewData()
        setupChart()
        
        
        let cellNib = UINib(nibName: "RunDataTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "RunDataTableViewCell")

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}



// MARK: - TableView

extension HistoryViewController {

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RunDataTableViewCell", forIndexPath: indexPath) as! RunDataTableViewCell
        for header in headers {
            cell.runDataStruct = runDataSortedByTime[header]![indexPath.row]
            cell.setup()
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // the number of sections
        return headers.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of rows
        return runDataSortedByTime[headers[section]]!.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // the height
        return 59
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //do something when touched
    }


    
}



// MARK: - Get Data

extension HistoryViewController {
    
    func prepareTableViewData() {
        runDataStructArray = runDataModel.getData()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM, YYYY"
        
        for runDataStruct in runDataStructArray {
            let header = dateFormatter.stringFromDate(runDataStruct.date!)
            
            if runDataSortedByTime.keys.contains(header) {
                runDataSortedByTime[header]?.append(runDataStruct)
            } else {
                runDataSortedByTime[header] = []
                runDataSortedByTime[header]?.append(runDataStruct)
            }
            
            if !headers.contains(header) {
                headers.append(header)
            }
        }
    }
}



// MARK: - Chart

extension HistoryViewController {
    
    func setupChart() {
        var distanceArray: [Double] = []
        var dateArray: [String] = []
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        for runDataStruct in runDataStructArray {
            distanceArray.append(runDataStruct.distance!)
            dateArray.append(dateFormatter.stringFromDate(runDataStruct.date!))
        }
        
        var dataEntries:[ChartDataEntry] = []
        
        for i in 0..<distanceArray.count {
            let dataEntry  = ChartDataEntry(value: distanceArray[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "")
        
        lineChartDataSet.fillColor = UIColor.blueColor()
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.lineWidth = 0.0
        
        let lineChartData = LineChartData(xVals: dateArray, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        
        lineChartView.backgroundColor = UIColor.clearColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.rightAxis.labelTextColor = .clearColor()
        lineChartView.rightAxis.gridColor = .whiteColor()
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.gridColor = .clearColor()
        lineChartView.xAxis.labelTextColor = .whiteColor()
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.legend.enabled = false
        lineChartView.descriptionText = ""
    }
}





















