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


struct runData {
    var date: NSDate?
    var distance: Double?
    var time: String?
}



// MARK: - Main

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    class func controller() -> HistoryViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var runDataStructArray: [runData] = []
    
    private let context = DataController().managedObjectContext
    
    private var headers: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        getData()
        setupChart()
        prepareTableViewData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}



// MARK: - TableView

extension HistoryViewController {
    
    func prepareTableViewData() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM, YYYY"
        
        for runDataStruct in runDataStructArray {
            let header = dateFormatter.stringFromDate(runDataStruct.date!)
            if !headers.contains(header){
                headers.append(header)
            }
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RunDataTableViewCell", forIndexPath: indexPath) as! RunDataTableViewCell
        
        for header in headers {
            var tempArray: [runData]
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM, YYYY"
            
            for runDataStruct in runDataStructArray {
                let headerOfRunDataStruct = dateFormatter.stringFromDate(runDataStruct.date!)
                if headerOfRunDataStruct == header {
                    tempArray.append(runDataStruct)
                }
            }
            
            switch headers[indexPath.section] {
            case header:
                let cell = tableView.dequeueReusableCellWithIdentifier("RunDataTableViewCell", forIndexPath: indexPath) as! RunDataTableViewCell
                cell.runDataStruct = tempArray[indexPath.row]
                
                return cell
            }
        }

        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // the number of sections
        return headers.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of rows
        for header in headers {
            var tempArray: [runData]

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM, YYYY"
            
            for runDataStruct in runDataStructArray {
                let headerOfRunDataStruct = dateFormatter.stringFromDate(runDataStruct.date!)
                if headerOfRunDataStruct == header {
                    tempArray.append(runDataStruct)
                }
            }

            switch headers[section] {
                case header: return tempArray.count
            }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // the height
        return 59
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //do something when touched
    }


    
}



// MARK: - Get Data

extension HistoryViewController {
    
    
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





















