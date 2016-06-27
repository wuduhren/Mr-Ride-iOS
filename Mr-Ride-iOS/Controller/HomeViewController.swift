//
//  ViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/23.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import Charts
import Amplitude_iOS


class HomeViewController: UIViewController {
    
    @IBOutlet weak var totalDistance: UILabel!
    private var totalDistanceLabelText: Double = 0
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var totalCount: UILabel!
    private var totalCountLabelText: Int = 0
    
    @IBOutlet weak var averageSpeed: UILabel!
    private var averageSpeedLabelText: Double = 0

    @IBOutlet weak var letsRideButton: UIButton!
    
    private var runDataStructArray: [RunDataModel.runDataStruct] = []
    
    
    deinit {
        //print("HomeViewController deinit at \(self)")
    }
}



// MARK: - Action

extension HomeViewController {
    
    @IBAction func letsRideButton(sender: UIButton) {
        let TrackingPageNavigationBar = self.storyboard?.instantiateViewControllerWithIdentifier("TrackingPageNavigationBar") as! UINavigationController
        let trackingPageViewController = TrackingPageNavigationBar.viewControllers[0] as? TrackingPageViewController
        trackingPageViewController?.delegate = self
        TrackingPageNavigationBar.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(TrackingPageNavigationBar, animated: true, completion: nil)
        hideLabels()
        
        Amplitude.instance().logEvent("select_ride_in_homePage")
    }
    
    func hideLabels() {
        for subview in view.subviews where subview is UILabel {
            subview.hidden = true
        }
    }
    
    func showLabels() {
        totalDistanceLabelText = 0
        setupLabels()
        
        setupChart()
        for subview in view.subviews where subview is UILabel {
            subview.hidden = false
        }
    }
}



// MARK: - Setup

extension HomeViewController {
    
    private func getRunData() {
        let runDataModel = RunDataModel()
        runDataStructArray = runDataModel.getData()
    }
    
    func setup() {
        setupLetsRideButton()
        setupChart()
        setupLabels()
    }

    private func setupChart() {
        getRunData()
        
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
        let gradientColors = [UIColor.MRLightblueColor().CGColor, UIColor.MRWaterBlueColor().CGColor]
        let colorLocations:[CGFloat] = [0.0, 0.19]
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradientColors, colorLocations)
        lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient!, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        
        
        let lineChartData = LineChartData(xVals: dateArray, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartData.setDrawValues(false)
        
        lineChartView.backgroundColor = UIColor.clearColor()
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.rightAxis.labelTextColor = .clearColor()
        lineChartView.rightAxis.gridColor = .clearColor()
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.gridColor = .clearColor()
        lineChartView.xAxis.labelTextColor = .clearColor()
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.xAxis.axisLineColor = .clearColor()
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

    private func setupLabels() {
        getRunData()
        
        for runDataStruct in runDataStructArray {
            totalDistanceLabelText += runDataStruct.distance!
            averageSpeedLabelText += runDataStruct.speed!
        }
        
        averageSpeedLabelText = averageSpeedLabelText / Double(runDataStructArray.count)
        totalCountLabelText = runDataStructArray.count
        
        totalDistance.text = "\(Int(totalDistanceLabelText)) km"
        totalCount.text = "\(totalCountLabelText) times"
        averageSpeed.text = "\(round(averageSpeedLabelText)) km/h"
        totalDistance.adjustsFontSizeToFitWidth = true
    }

    private func setupLetsRideButton() {
        
        let roundedLayer = CAShapeLayer()
        let roundedPath = UIBezierPath(
            roundedRect: letsRideButton.bounds,
            byRoundingCorners: [ .BottomLeft, .BottomRight, .TopRight, .TopLeft ],
            cornerRadii: CGSize(width: 30.0, height: 30.0)
        )
        roundedLayer.path = roundedPath.CGPath
        roundedLayer.path = roundedPath.CGPath
        roundedLayer.frame = letsRideButton.bounds
        roundedLayer.masksToBounds = true
        roundedLayer.fillColor = UIColor.whiteColor().CGColor
        letsRideButton.layer.insertSublayer(roundedLayer, atIndex: 0)
        
        letsRideButton.layer.shadowColor = UIColor.blackColor().CGColor
        letsRideButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        letsRideButton.layer.shadowOpacity = 0.25
        letsRideButton.layer.shadowRadius = 3.0
        letsRideButton.layer.shadowPath = roundedPath.CGPath
        
        
        letsRideButton.addTarget(self, action: #selector(HomeViewController.touchDown(_:)), forControlEvents: UIControlEvents.TouchDown)
        letsRideButton.addTarget(self, action: #selector(HomeViewController.touchUp(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func touchDown(sender: UIButton) {
        letsRideButton.layer.shadowColor = UIColor.clearColor().CGColor
        letsRideButton.setTitleShadowColor(.clearColor(), forState: .Normal)
    }
    func touchUp(sender: UIButton) {
        letsRideButton.layer.shadowColor = UIColor.blackColor().CGColor
        letsRideButton.setTitleShadowColor(.grayColor(), forState: .Normal)
    }
}



// MARK: - View LifeCycle

extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //print("HomeViewController viewDidLoad at \(self)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // Amplitude Log
        Amplitude.instance().logEvent("view_in_home")
    }
    
}



// MARK: -  Initializer

extension HomeViewController {
    
    class func controller() -> HomeViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    }
}