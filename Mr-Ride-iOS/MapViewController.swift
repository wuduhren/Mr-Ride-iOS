//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    

    @IBOutlet weak var lookForButton: UIButton!
    var templookForButtonText = ""
    
    @IBOutlet weak var pickerViewWindow: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let lookForOption = ["Toilet", "Ubike Station"]
    
    var toilets: [ToiletModel] = []
    
    var youbikes: [YoubikeModel] = []
    
}



// MARK: - Map

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            mapView.camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
        }
    }
    
    func setupToiletMarkers() {
        
        for toilet in toilets {
            let  position = toilet.coordinate
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "icon-toilet")
            marker.title = "\(toilet.location)"
            marker.map = mapView
        }
    }
    
    func setupYoubikeMarkers() {
        
        for youbike in youbikes {
            let  position = youbike.coordinate
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "icon-station")
            marker.title = "\(youbike.bikeRemain) bikes left"
            marker.map = mapView
        }
    }

    
    
    func setupMap() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
}



// MARK: - Data

extension MapViewController {
    
    private func getToiletsData() {
    
        let mapDataManager = MapDataManager()
        
        mapDataManager.getToilets(
            success: { [weak self] toilets in
                
                guard let weakSelf = self else { return }

                weakSelf.toilets = toilets
                
                //weakSelf.setupToiletMarkers()
            },
            failure: { error in
                
                print("ERROR: \(error)")
            }
        )
        
    }
    
    private func getYoubikeData() {
        
        let mapDataManager = MapDataManager()
        
        mapDataManager.getYoubikes(
            success: { [weak self] youbikes in
                
                guard let weakSelf = self else { return }
                
                weakSelf.youbikes = youbikes
                
                weakSelf.setupYoubikeMarkers()
            },
            failure: { error in
                
                print("ERROR: \(error)")
            }
        )
        
    }

    
    
    
}




// MARK: - View LifeCycle

extension MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickerView()
        getToiletsData()
        getYoubikeData()
        setupMap()
    }
}



// MARK: - PickerViewSetup

extension MapViewController {
    
    func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerViewWindow.hidden = true
    }
    
    @IBAction func lookForButton(sender: UIButton) {
        pickerViewWindow.hidden = false
    }
    
    @IBAction func pickerViewWindowDoneButton(sender: UIButton) {
        pickerViewWindow.hidden = true
        lookForButton.titleLabel?.text = templookForButtonText
    }
    
    @IBAction func pickerViewWindowCancelButton(sender: UIButton) {
        pickerViewWindow.hidden = true
        templookForButtonText = ""
    }
}



// MARK: - PickerViewDataSource and Delegate

extension MapViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lookForOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lookForOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        templookForButtonText = lookForOption[row]
    }
}



// MARK: -  Initializer

extension MapViewController {
    
    class func controller() -> MapViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
    }
}
