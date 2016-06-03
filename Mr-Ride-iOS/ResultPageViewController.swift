//
//  ResultPageViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/27.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import CoreData

class ResultPageViewController: UIViewController {

    @IBOutlet weak var closeButtonToHomePage: UIBarButtonItem!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var speedAverageLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var date = NSDate()
    
    private var polylineDataNSData: NSData?
    private var locationArray: [CLLocation] = []
    
    let runDataModel = RunDataModel()
    var runDataStructArray: [RunDataModel.runDataStruct] = []
    var runDataStruct = RunDataModel.runDataStruct()

    
    
    @IBAction func closeButtonToHomePage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func setupNavigationItem() {
        closeButtonToHomePage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font(),
            NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Normal)
        
        //title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(date)
        navigationController?.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        getData()
        parsePolylineData()
        drawPolyline()
        calculateCameraCenter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



extension ResultPageViewController {
    
    func getData() {
        runDataStructArray = runDataModel.getData()
        runDataStruct = runDataStructArray.last!
        
        date = runDataStruct.date!
        distanceLabel.text = "\(round(runDataStruct.distance!)) m"
        speedAverageLabel.text = "\(round(runDataStruct.speed!)) km / h"
        caloriesLabel.text = "\(round(runDataStruct.calories!)) kcal"
        timeLabel.text = runDataStruct.time
        polylineDataNSData = runDataStruct.polyline
    }
    
    func parsePolylineData() {
        guard
            let polylineData = NSKeyedUnarchiver.unarchiveObjectWithData(polylineDataNSData!),
            let polyline = polylineData as? [Dictionary<String, AnyObject>]
        else { return }
        for item in polyline {
            if let latitude = item["latitude"]?.doubleValue,
                let longitude = item["longitude"]?.doubleValue {
                let location = CLLocation(latitude: latitude, longitude: longitude)
                locationArray.append(location)
            }
        }
    }
    
    func drawPolyline() {
        let path = GMSMutablePath()
        
        for location in locationArray {
            path.addCoordinate(location.coordinate)
        }
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10.0
        polyline.geodesic = true
        polyline.spans = [GMSStyleSpan(color: UIColor.MRBubblegumColor())]
        polyline.map = mapView
        
    }
    
    func calculateCameraCenter() {
        var maxLatitude: Double = -1000
        var maxLongitude: Double = -1000
        var minLatitude: Double = 1000
        var minLongitude: Double = 1000

        for location in locationArray {
            if location.coordinate.latitude > maxLatitude {
                maxLatitude = location.coordinate.latitude
                
            }
            if location.coordinate.latitude > maxLongitude {
                maxLongitude = location.coordinate.longitude
            }
            if location.coordinate.latitude < minLatitude {
                minLatitude = location.coordinate.latitude
            }
            if location.coordinate.latitude < minLongitude {
                minLongitude = location.coordinate.longitude
            }

        }
        let centerCoordinate = CLLocationCoordinate2DMake((maxLatitude + minLatitude) / 2, (maxLongitude + minLongitude) / 2)
        mapView.camera = GMSCameraPosition(target: centerCoordinate, zoom: 14, bearing: 0, viewingAngle: 0)
    }
    
    
    
}
































