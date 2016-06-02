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

class HistoryViewController: UIViewController {

    class func controller() -> HistoryViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
    
    @IBOutlet var lineChartView: LineChartView!
    
    private var runDataStructArray: [runData] = []
    
    private let context = DataController().managedObjectContext
    private let getRequest = NSFetchRequest(entityName: "Entity")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
}



// MARK: - Get Data

extension HistoryViewController {
    
    func getData() {
        do {
            let data = try context.executeFetchRequest(getRequest)
            for eachEntity in data {
                var tempStruct = runData()
                tempStruct.date = eachEntity.valueForKey("date")! as? NSDate
                tempStruct.distance = eachEntity.valueForKey("distance")! as? Double
                tempStruct.time = eachEntity.valueForKey("time")! as? String
                runDataStructArray.append(tempStruct)
            }
        } catch {
            fatalError("error appear when fetching")
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





















