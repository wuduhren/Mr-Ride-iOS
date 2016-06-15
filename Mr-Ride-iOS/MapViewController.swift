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
    
    
    //info view
    enum MarkerStatus: String {
        case Toilets
        case Youbikes
    }
    var markerStatus: MarkerStatus = .Youbikes
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var districtLabel: UILabel!
    
    @IBOutlet weak var walkingTimeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    

    //pickerview
    @IBOutlet weak var lookForButton: UIButton!
    var templookForButtonText = ""
    
    @IBOutlet weak var pickerViewWindow: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let lookForOption = ["Ubike Station", "Toilet"]
    
    
    //data
    private var toilets: [ToiletModel] = []
    
    private var youbikes: [YoubikeModel] = []
    
}



// MARK: - Map

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            mapView.camera = GMSCameraPosition(target: currentLocation.coordinate, zoom: 16, bearing: 0, viewingAngle: 0)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        infoView.hidden = false
        
        switch markerStatus {
            
        case .Youbikes:
            guard let youbikeIndex = marker.userData as? Int else { return false }
            districtLabel.text = youbikes[youbikeIndex].district
            districtLabel.layer.borderColor = UIColor.whiteColor().CGColor
            districtLabel.layer.borderWidth = 0.5
            
            nameLabel.text = youbikes[youbikeIndex].name
            locationLabel.text = youbikes[youbikeIndex].location
            
        case .Toilets:
            guard let toiletIndex = marker.userData as? Int else { return false }
            districtLabel.hidden = true
            nameLabel.text = toilets[toiletIndex].location
            locationLabel.hidden = true
        }
        
        return false
        
    }
    
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        infoView.hidden = true
        pickerViewWindow.hidden = true
        
    }
        
    func setupToiletMarkers() {
        mapView.clear()
        
        var toiletIndex = 0
        for toilet in toilets {
            let  position = toilet.coordinate
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "icon-toilet")
            marker.title = "\(toilet.location)"
            marker.userData = toiletIndex
            marker.map = mapView
            
            toiletIndex += 1
        }
    }
    
    func setupYoubikeMarkers() {
        mapView.clear()
        
        var youbikeIndex = 0
        for youbike in youbikes {
            let  position = youbike.coordinate
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: "icon-station")
            marker.title = "\(youbike.bikeRemain) bikes left"
            marker.userData = youbikeIndex
            marker.map = mapView
            
            youbikeIndex += 1
        }
    }

    
    
    func setupMap() {
        mapView.delegate = self
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



// MARK: - Setup

extension MapViewController {
    func setup() {
        getToiletsData()
        getYoubikeData()
        setupMap()
        
        infoView.hidden = true
        setupPickerView()
    }
    
}



// MARK: - View LifeCycle

extension MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        
        switch row {
            case 0:
                markerStatus = .Youbikes
                setupYoubikeMarkers()
            case 1:
                markerStatus = .Toilets
                setupToiletMarkers()
            default: break
        }
        
        templookForButtonText = lookForOption[row]
    }
}



// MARK: -  Initializer

extension MapViewController {
    
    class func controller() -> MapViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
    }
}
