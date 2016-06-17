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


class HistoryViewController: UIViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let runDataModel = RunDataModel()
    private var runDataStructArray: [RunDataModel.runDataStruct] = []
    
    private var runDataSortedByTime: [String: [RunDataModel.runDataStruct]] = [:]
    private var headers: [String] = []
    
    enum CellStatus {
        case recordCell
        case gap
    }
    var cellStatus: CellStatus = .gap
}



// MARK: - View LifeCycle

extension HistoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        clearData()
        prepareTableViewData()
        setupChart()
    }
}



// MARK: - TableViewDataSource and Delegate

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let cellNib = UINib(nibName: "RunDataTableViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "RunDataTableViewCell")
        let gapCellNib = UINib(nibName: "RunDataTableViewGapCell", bundle: nil)
        tableView.registerNib(gapCellNib, forCellReuseIdentifier: "RunDataTableViewGapCell")

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        for header in headers {
            
            // first and last return gap cell
            if indexPath.row == 0 || indexPath.row == runDataSortedByTime[header]!.count + 1 {
                cellStatus = .gap
                
                let cell = tableView.dequeueReusableCellWithIdentifier("RunDataTableViewGapCell", forIndexPath: indexPath) as! RunDataTableViewGapCell
                return cell
                
            } else {
                cellStatus = .recordCell
                
                let cell = tableView.dequeueReusableCellWithIdentifier("RunDataTableViewCell", forIndexPath: indexPath) as! RunDataTableViewCell
                cell.runDataStruct = runDataSortedByTime[header]![indexPath.row - 1]
                cell.setup()
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // the number of sections
        return headers.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // the number of rows
        return runDataSortedByTime[headers[section]]!.count + 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // the height
        if cellStatus == .recordCell {
            return 59
        } else if cellStatus == .gap {
            return 10
        } else {
            print("Something Wrong in HistoryView Cell's Height")
            return 59
        }
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let resultPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultPageViewController") as! ResultPageViewController
        
        for header in headers {
            resultPageViewController.runDataStruct = runDataSortedByTime[header]![indexPath.row - 1]
            resultPageViewController.previousPage = .HistoryViewController
        }
        navigationController?.pushViewController(resultPageViewController, animated: true)
    }
}



// MARK: - Data

extension HistoryViewController {
    
    private func prepareTableViewData() {
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
        dispatch_async(dispatch_get_main_queue()) { self.tableView.reloadData() }
    }
    
    private func clearData() {
        runDataStructArray = []
        runDataSortedByTime = [:]
        headers = []
    }
}



// MARK: - Setup

extension HistoryViewController {
    
    private func setupBackground() {
        print("setupBackground")
        let gradientLayer = CAGradientLayer()
//        gradientLayer.backgroundColor = UIColor.MRRedColor().CGColor
        gradientLayer.colors = [UIColor.MRLightblueColor().CGColor, UIColor.MRPineGreen50Color().CGColor]
        gradientLayer.locations = [0.5, 1]
        gradientLayer.frame = view.frame
        self.view.layer.insertSublayer(gradientLayer, atIndex: 1)
        print()
        
    }
    
    private func setupChart() {
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
        
        //Gradient Fill
        let gradientColors = [UIColor.MRBrightSkyBlue().CGColor, UIColor.MRTurquoiseBlue().CGColor]
        let colorLocations:[CGFloat] = [0.0, 0.05]
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations)
        lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        
        
        
        let lineChartData = LineChartData(xVals: dateArray, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartData.setDrawValues(false)
        
        lineChartView.backgroundColor = UIColor.clearColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.rightAxis.labelTextColor = .clearColor()
        lineChartView.rightAxis.gridColor = .whiteColor()
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.gridColor = .clearColor()
        lineChartView.xAxis.labelTextColor = .whiteColor()
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.axisLineColor = .whiteColor()
        lineChartView.legend.enabled = false
        lineChartView.descriptionText = ""
        lineChartView.userInteractionEnabled = false
        
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        //lineChartView.rightAxis.drawGridLinesEnabled = false
        //lineChartView.leftAxis.gridColor = UIColor.whiteColor()
    }
}



// MARK: - Initializer

extension HistoryViewController {
    
    class func controller() -> HistoryViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
}





















