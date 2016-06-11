//
//  TrackingPageViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/26.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import CoreData

class TrackingPageViewController: UIViewController {
    
    //view
    @IBOutlet weak var finishButtonToResultPage: UIBarButtonItem!
    
    @IBOutlet weak var cancelButtonToHomePage: UIBarButtonItem!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var speedAverageLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var stopWatchButton: UIButton!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    //map
    private let locationManager = CLLocationManager()
    
    private var locationArray: [CLLocation] = []
    private var locationArrayForPolyline: [CLLocation] = []
    
    //properties
    private var totalInterval: NSTimeInterval = 0
    
    private var distance: Double = 0
    
    private var averageSpeed: Double = 0

    var polylineCoordinates: [Dictionary<String, AnyObject>] = []
    
    //stopWatch
    private enum buttonMode {
        case counting, notCounting
    }
    
    private var buttonStatus = buttonMode.notCounting
    
    private let stopwatch = Stopwatch()
    
    
}



// MARK: - StopWatch

extension TrackingPageViewController {
    
    @IBAction func stopWatchButton(sender: UIButton) {
        
        //Button Animation
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            switch self.buttonStatus {
            case .counting:
                self.stopWatchButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.stopWatchButton.layer.cornerRadius = 15
                self.stopWatchButton.clipsToBounds = true
                
            case .notCounting:
                //self.stopWatchButton.frame.size = CGSize(width: 52, height: 52)
                self.stopWatchButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
                self.stopWatchButton.layer.cornerRadius = self.stopWatchButton.frame.width / 2
                self.stopWatchButton.clipsToBounds = true
            }
        })
        
        //Button Counting and Mapping
        switch buttonStatus {
        case .counting:
            stopwatch.pause()
            locationArrayForPolyline += locationArray
            locationArray = []
        case .notCounting:
            NSTimer.scheduledTimerWithTimeInterval(
                0.01,
                target: self,
                selector: #selector(TrackingPageViewController.updateElapsedTimeLabel(_:)),
                userInfo: nil,
                repeats: true
            )
            stopwatch.start()
        }
        
        //Changing Status
        if buttonStatus == .notCounting {
            buttonStatus = .counting
            
        } else {
            buttonStatus = .notCounting
        }
        
    }
    
    @IBAction func finishRunning(sender: UIBarButtonItem) {
        if buttonStatus == .counting {
            locationArrayForPolyline += locationArray
        }
        stopwatch.stop()
        locationManager.stopUpdatingLocation()
        saveData()
        performSegueWithIdentifier("ResultPageViewControllerSegue", sender: self)
    }
    
    @IBAction func cancelButtonToHomePage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func updateElapsedTimeLabel(timer: NSTimer) {
        
        if stopwatch.intervalBeforPause != nil {
            totalInterval = stopwatch.intervalBeforPause! + stopwatch.elapsedTime
        } else {
            totalInterval = stopwatch.elapsedTime
        }
        
        if stopwatch.isRunning {
            let hours = Int(totalInterval / 3600)
            let minutes = Int(totalInterval / 60)
            let seconds = Int(totalInterval % 60)
            let tenthsOfSecond = Int(totalInterval * 100 % 100)
            stopwatch.elapsedTimeLabelText = String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, tenthsOfSecond)
            timeLabel.text = stopwatch.elapsedTimeLabelText
        } else {
            timer.invalidate()
        }
    }
}



// MARK: - Map

extension TrackingPageViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            
            mapView.camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            
            if locationArray.count > 0 && buttonStatus == .counting {
                distance += currentLocation.distanceFromLocation(locationArray.last!)
                
                let path = GMSMutablePath()
                path.addCoordinate(currentLocation.coordinate)
                path.addCoordinate(locationArray.last!.coordinate)
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 10.0
                polyline.geodesic = true
                polyline.spans = [GMSStyleSpan(color: UIColor.MRBubblegumColor())]
                polyline.map = mapView
            }
            
            //update labels
            distanceLabel.text = "\(round(distance)) m"
            speedAverageLabel.text = "\(round(currentLocation.speed * 3.6)) km / h"
            caloriesLabel.text = NSString(format:"%.2f kcal",getCaloriesBurned()) as String
            
            if buttonStatus == .counting {
                locationArray.append(currentLocation)
            }
        }
    }
    
}



// MARK: - Setup

extension TrackingPageViewController {
    func setup() {
        setupNavigationItem()
        setupBackground()
        setupStopWatchButton()
        setupMap()
    }

    func setupStopWatchButton() {
        stopWatchButton.backgroundColor = .redColor()
        self.stopWatchButton.layer.cornerRadius = self.stopWatchButton.frame.width/2
        self.stopWatchButton.clipsToBounds = true
    }
    
    func setupNavigationItem() {
        cancelButtonToHomePage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font() ], forState: UIControlState.Normal)
        finishButtonToResultPage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font() ], forState: UIControlState.Normal)
        
        //title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(NSDate())
        navigationController?.navigationBar.titleTextAttributes = ([NSFontAttributeName: UIFont.mrTextStyle13Font(), NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func setupBackground() {
        
        self.view.backgroundColor = UIColor.MRLightblueColor()
        let topGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60).CGColor
        let bottomGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).CGColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [topGradient, bottomGradient]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}



// MARK: - View LifeCycle

extension TrackingPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}



// MARK: - Data

extension TrackingPageViewController {
    
    func getPolylineData() -> NSData {
        for location in locationArrayForPolyline {
            let longitude = NSNumber(double: Double(location.coordinate.longitude))
            let latitude = NSNumber(double: Double(location.coordinate.latitude))
            let coordinate = ["longitude": longitude, "latitude": latitude]
            polylineCoordinates.append(coordinate)
        }
        let polylineData = NSKeyedArchiver.archivedDataWithRootObject(polylineCoordinates)
        return polylineData
    }
    
    func getAverageSpeed() -> Double {
        var arrayForSpeed = locationArrayForPolyline
        
        if locationArrayForPolyline.count == 0 {
            if locationArray.count == 0 {
                return 0
            } else {
                arrayForSpeed = locationArray
            }
        }
        
        for location in arrayForSpeed {
            averageSpeed += Double(location.speed)
        }
        averageSpeed = averageSpeed / Double(arrayForSpeed.count)
        return averageSpeed
    }
    
    func getCaloriesBurned() -> Double {
        let calorieCalculator = CalorieCalculator()
        let defaultName = NSUserDefaults.standardUserDefaults()
        guard let weight = defaultName.valueForKey("weight") as? Double else { return 0 }
        let kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: getAverageSpeed(), weight: weight, time: totalInterval/3600)
        return kCalBurned
    }
    
    func saveData() {
        let context = DataController().managedObjectContext
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: context)
        entity.setValue(NSDate(), forKey: "date")
        entity.setValue(distance, forKey: "distance")
        entity.setValue(getAverageSpeed(), forKey: "speed")
        entity.setValue(getCaloriesBurned(), forKey: "calories")
        entity.setValue(timeLabel.text, forKey: "time")
        entity.setValue(getPolylineData(), forKey: "polyline")
        do {
            try context.save()
        } catch {
            fatalError("Failure to save context.")
        }
    }
    
}














