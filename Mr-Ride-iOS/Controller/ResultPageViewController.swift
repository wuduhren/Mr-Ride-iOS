//
//  ResultPageViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/27.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import CoreData
import Amplitude_iOS
import Social

class ResultPageViewController: UIViewController {
    
    weak var delegate: TrackingPageViewController?
    
    @IBOutlet weak var ShareToFacebookButton: UIBarButtonItem!
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var speedAverageLabel: UILabel!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var date = NSDate()
    
    //map data
    private var polylineDataNSData: NSData?
    private var locationArray: [CLLocation] = []
    
    //data
    private let runDataModel = RunDataModel()
    var runDataStructArray: [RunDataModel.runDataStruct] = []
    var runDataStruct = RunDataModel.runDataStruct()
    
    enum PreviousPage {
        case TrackingPageViewController
        case HistoryViewController
    }
    var previousPage: PreviousPage = .TrackingPageViewController
}



// MARK: - Setup

extension ResultPageViewController {
    
    private func setupNavigationItem() {
        if previousPage == .TrackingPageViewController {
            let closeButtonToHomePage = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(closeButtonToHomePage(_:)))
            closeButtonToHomePage.tintColor = UIColor.whiteColor()
            navigationItem.leftBarButtonItem = closeButtonToHomePage
            
            closeButtonToHomePage.setTitleTextAttributes([
                NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()
                ],
                forState: UIControlState.Normal
            )
        }
        
        if previousPage == .HistoryViewController {
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        }
        
        //title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(date)
        navigationController?.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        //Share button
        ShareToFacebookButton.setTitleTextAttributes([
            NSFontAttributeName: UIFont.mrTextStyle13Font(),
            NSForegroundColorAttributeName: UIColor.whiteColor()
            ],forState: UIControlState.Normal
        )
    }
    
    private func setupBackground() {
        if previousPage == .HistoryViewController {
            view.backgroundColor = UIColor.MRDarkSlateBlueColor()
        } else if previousPage == .TrackingPageViewController {
            //gradient
            view.backgroundColor = UIColor.clearColor()
            let topGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.60).CGColor
            let bottomGradient = UIColor(red: 0, green: 0, blue: 0, alpha: 0.40).CGColor
            let gradient = CAGradientLayer()
            gradient.frame = self.view.frame
            gradient.colors = [topGradient, bottomGradient]
            self.view.layer.insertSublayer(gradient, atIndex: 0)
        } else {
            view.backgroundColor = UIColor.MRDarkSlateBlueColor()
        }
    }
}

// MARK: - View LifeCycle

extension ResultPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupBackground()
        setupNavigationItem()
        drawPolyline()
        calculateCameraCenter()
        
        Amplitude.instance().logEvent("view_in_record_resultPage", withEventProperties: ["record_id": "\(runDataStruct.objectID)"])
    }
}



// MARK: - Map

extension ResultPageViewController {
    
    private func drawPolyline() {
        parsePolylineData()
        
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
    
    private func calculateCameraCenter() {
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
        mapView.camera = GMSCameraPosition(target: centerCoordinate, zoom: 1, bearing: 0, viewingAngle: 0)
        
        let northEastCoordinate = CLLocationCoordinate2DMake(maxLatitude, maxLongitude)
        let southWestCoordinate = CLLocationCoordinate2DMake(minLatitude, minLongitude)
        let coordinateBounds = GMSCoordinateBounds(coordinate: northEastCoordinate, coordinate: southWestCoordinate)
        let update = GMSCameraUpdate.fitBounds(coordinateBounds, withPadding: 50.0)
        mapView.moveCamera(update)
    }
}


// MARK: - Share

extension ResultPageViewController {
    
    @IBAction func fbShareAction(sender: AnyObject) {
        //create screenShot
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)

        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Share
        let facebookSharingController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSharingController.addImage(screenShot)
        self.presentViewController(facebookSharingController, animated: true, completion: nil)
    }
}




// MARK: - Data

extension ResultPageViewController {
    
    private func getData() {
        
        if previousPage == .TrackingPageViewController {
            runDataStructArray = runDataModel.getData()
            runDataStruct = runDataStructArray.last!
        }
        date = runDataStruct.date!
        distanceLabel.text = NSString(format:"%.1f m", runDataStruct.distance!) as String
        speedAverageLabel.text = NSString(format:"%.1f km / h", runDataStruct.speed! * 3.6) as String
        caloriesLabel.text = NSString(format:"%.2f kcal", runDataStruct.calories!) as String
        timeLabel.text = runDataStruct.time
        polylineDataNSData = runDataStruct.polyline
    }
    
    private func parsePolylineData() {
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
    
}



// MARK: - Action

extension ResultPageViewController {
    
    @IBAction func closeButtonToHomePage(sender: UIBarButtonItem) {
        delegate?.delegate?.showLabels()
        self.dismissViewControllerAnimated(true, completion: {})
        
        Amplitude.instance().logEvent("select_close_in_history", withEventProperties: ["record_id": "\(runDataStruct.objectID)"])
    }
}
