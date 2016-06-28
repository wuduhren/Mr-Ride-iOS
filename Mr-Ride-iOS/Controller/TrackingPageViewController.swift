//
//  TrackingPageViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/26.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import CoreData
import Amplitude_iOS

class TrackingPageViewController: UIViewController {
    
    
    weak var delegate: HomeViewController?
    
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
    
    deinit {
        //print("TrackingPageViewController deinit at \(self)")
    }
}



// MARK: - StopWatch

extension TrackingPageViewController {
    
    @IBAction func stopWatchButton(sender: UIButton) {
        
        //Button Animation
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            switch self.buttonStatus {
            case .counting:
                self.stopWatchButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                self.stopWatchButton.layer.cornerRadius = self.stopWatchButton.frame.width / 2
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
            
            Amplitude.instance().logEvent("select_start_in_trackingPage")
            
        } else {
            buttonStatus = .notCounting
            
            Amplitude.instance().logEvent("select_pause_in_trackingPage")

        }
        
    }
    
    @IBAction func finishRunning(sender: UIBarButtonItem) {
        if buttonStatus == .counting {
            locationArrayForPolyline += locationArray
        }
        stopwatch.stop()
        saveData()
        performSegueWithIdentifier("ResultPageViewControllerSegue", sender: self)
        
        Amplitude.instance().logEvent("select_finish_in_trackingPage")
    }
    
    @IBAction func cancelButtonToHomePage(sender: UIBarButtonItem) {
        delegate?.showLabels()
        self.dismissViewControllerAnimated(true, completion: {})
        Amplitude.instance().logEvent("select_cancel_in_trackingPage")
        
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
            
            if currentLocation.speed < 0 {
                speedAverageLabel.text = "0 km / h"
            } else {
                speedAverageLabel.text = "\(round(currentLocation.speed * 3.6)) km / h"
            }
            caloriesLabel.text = NSString(format:"%.2f kcal",getCaloriesBurned()) as String
            
            
            
            if buttonStatus == .counting {
                locationArray.append(currentLocation)
            }
        }
    }
    
}



// MARK: - Setup

extension TrackingPageViewController {
    private func setup() {
        setupNavigationItem()
        setupBackground()
        setupStopWatchButton()
        setupMap()
    }

    private func setupStopWatchButton() {
        stopWatchButton.backgroundColor = .redColor()
        self.stopWatchButton.layer.cornerRadius = self.stopWatchButton.frame.width/2
        self.stopWatchButton.clipsToBounds = true
    }
    
    private func setupNavigationItem() {
        cancelButtonToHomePage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font() ], forState: UIControlState.Normal)
        finishButtonToResultPage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font() ], forState: UIControlState.Normal)
        
        //title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(NSDate())
        navigationController?.navigationBar.titleTextAttributes = ([NSFontAttributeName: UIFont.mrTextStyle13Font(), NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    private func setupBackground() {
        
        self.view.backgroundColor = UIColor.clearColor()
        let topGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60).CGColor
        let bottomGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).CGColor
        let gradient = CAGradientLayer()
        gradient.frame = self.view.frame
        gradient.colors = [topGradient, bottomGradient]
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    private func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}



// MARK: - View LifeCycle

extension TrackingPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        Amplitude.instance().logEvent("view_in_trackingPage")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(true)
        setupMap()
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.delegate = nil
        super.viewWillDisappear(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ResultPageViewControllerSegue" {
            let resultPageViewController = segue.destinationViewController as? ResultPageViewController
            resultPageViewController?.delegate = self
        }
    }
}



// MARK: - Data

extension TrackingPageViewController {
    
    private func getPolylineData() -> NSData {
        for location in locationArrayForPolyline {
            let longitude = NSNumber(double: Double(location.coordinate.longitude))
            let latitude = NSNumber(double: Double(location.coordinate.latitude))
            let coordinate = ["longitude": longitude, "latitude": latitude]
            polylineCoordinates.append(coordinate)
        }
        let polylineData = NSKeyedArchiver.archivedDataWithRootObject(polylineCoordinates)
        return polylineData
    }
    
    private func getAverageSpeed() -> Double {
        var arrayForSpeed = locationArrayForPolyline
        
        if locationArrayForPolyline.count == 0 {
            if locationArray.count == 0 {
                return 0
            } else {
                arrayForSpeed = locationArray
            }
        }
        
        for location in arrayForSpeed {
            if Double(location.speed) > 0 {
                averageSpeed += Double(location.speed)
            }
        }
        averageSpeed = averageSpeed / Double(arrayForSpeed.count)
        return averageSpeed
    }
    
    private func getCaloriesBurned() -> Double {
        let calorieCalculator = CalorieCalculator()
        let defaultName = NSUserDefaults.standardUserDefaults()
        guard let weight = defaultName.valueForKey("weight") as? Double else { return 0 }
        var kCalBurned = calorieCalculator.kiloCalorieBurned(.Bike, speed: getAverageSpeed(), weight: weight, time: totalInterval/3600)
        if kCalBurned < 0 { kCalBurned = 0}
        return kCalBurned
    }
    
    private func saveData() {
        let context = DataController().managedObjectContext
        if let entity = NSEntityDescription.insertNewObjectForEntityForName("Entity", inManagedObjectContext: context) as? Entity {
            
            entity.date = NSDate()
            entity.distance = distance
            entity.speed = getAverageSpeed()
            entity.calories = getCaloriesBurned()
            entity.time = timeLabel.text
            entity.polyline = getPolylineData()
        }
        context.performBlock {
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context.")
            }
        }
    }
    
}














