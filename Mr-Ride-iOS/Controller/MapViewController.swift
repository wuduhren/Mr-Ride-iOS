//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import MapKit
import Amplitude_iOS

class MapViewController: UIViewController {
    
    //map
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    private var didSetCamera = false
    private var currentLocation: CLLocation?
    
    var tempMarker: GMSMarker?
    
    //info view
    private enum MarkerStatus: String {
        case PublicToilets
        case RiversideToilets
        case Youbikes
    }
    private var markerStatus: MarkerStatus = .Youbikes
    
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var districtLabel: UILabel!
    
    @IBOutlet weak var estimatedArrivalTimeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    

    //pickerview
    @IBOutlet weak var lookForButton: UIButton!
    private var templookForButtonText = "Youbike"
    
    @IBOutlet weak var pickerViewWindow: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    private let pickerTitle = ["Youbike", "Riverside Toilets", "Public Toilets"]
    
    
    //data
    private var riversideToilets: [RiversideToiletModel] = []
    
    private var youbikes: [YoubikeModel] = []
    
    private var publicToilets: [PublicToiletModel] = []
    
    
    deinit {
        print("MapViewController deinit at \(self)")
    }

}



// MARK: - Map

extension MapViewController: GMSMapViewDelegate, MKMapViewDelegate {
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        infoView.hidden = false
        
        //close picker window
        pickerViewWindow.hidden = true
        lookForButton.setTitle(templookForButtonText, forState: .Normal)
        
        tempMarker?.iconView.backgroundColor = .whiteColor()
        
        switch markerStatus {
            
        case .Youbikes:
            
            guard let youbikeIndex = marker.userData as? Int else { return false }
            districtLabel.hidden = false
            districtLabel.text = youbikes[youbikeIndex].district
            districtLabel.layer.borderColor = UIColor.whiteColor().CGColor
            districtLabel.layer.borderWidth = 0.7
            locationLabel.hidden = false
            
            nameLabel.text = youbikes[youbikeIndex].name
            locationLabel.text = youbikes[youbikeIndex].location
            setupEstimatedArrivalTimeLabel(marker.position)
            marker.iconView.backgroundColor = .MRLightblueColor()
            tempMarker = marker
            
            Amplitude.instance().logEvent("select_youbike_map", withEventProperties: ["youbike_id": "\( youbikes[youbikeIndex].identifier)"])
            
        case .RiversideToilets:
            
            guard let riversideToiletIndex = marker.userData as? Int else { return false }
            districtLabel.hidden = true
            nameLabel.text = riversideToilets[riversideToiletIndex].location
            locationLabel.hidden = true
            setupEstimatedArrivalTimeLabel(marker.position)
            marker.iconView.backgroundColor = .MRLightblueColor()
            tempMarker = marker
            
            Amplitude.instance().logEvent("select_riverside_toilet_map", withEventProperties: ["riverside_toilet_id": "\(riversideToilets[riversideToiletIndex].identifier)"])
            
        case .PublicToilets:
            
            guard let publicToiletIndex = marker.userData as? Int else { return false }
            districtLabel.hidden = false
            districtLabel.text = publicToilets[publicToiletIndex].district
            districtLabel.layer.borderColor = UIColor.whiteColor().CGColor
            districtLabel.layer.borderWidth = 0.7
            locationLabel.hidden = false
            
            nameLabel.text = publicToilets[publicToiletIndex].name
            locationLabel.text = publicToilets[publicToiletIndex].location
            setupEstimatedArrivalTimeLabel(marker.position)
            marker.iconView.backgroundColor = .MRLightblueColor()
            tempMarker = marker
            
            Amplitude.instance().logEvent("select_public_toilet_map", withEventProperties: ["public_toilet_id": "\(publicToilets[publicToiletIndex].identifier)"])

        }
        
        
        
        return false
        
    }
    
    
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        infoView.hidden = true
        pickerViewWindow.hidden = true
    }
    
    private func getMarkerIconImage(iconImageName: String) -> UIView {
        
        let iconImage = UIImage(named: iconImageName)
        let tintedImage = iconImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let iconImageView = UIImageView(image: tintedImage!)
        iconImageView.tintColor = .MRDarkSlateBlueColor()
        
        let iconBackgroundView = UIView()
        iconBackgroundView.backgroundColor = .whiteColor()
        iconBackgroundView.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        iconBackgroundView.layer.cornerRadius = iconBackgroundView.frame.width / 2
        iconBackgroundView.clipsToBounds = true
        
        iconBackgroundView.addSubview(iconImageView)
        iconImageView.center = iconBackgroundView.center
        
        return iconBackgroundView
    }
    
    private func setupPublicToiletMarkers() {
        mapView.clear()
        publicToilets = publicToilets.filter(isNearCurrentLocation)
        var publicToiletIndex = 0
        for publicToilet in publicToilets {
            let  position = publicToilet.coordinate
            let marker = GMSMarker(position: position)
            marker.iconView = getMarkerIconImage("icon-toilet")
            marker.title = "\(publicToilet.name)"
            marker.userData = publicToiletIndex
            marker.map = mapView
            publicToiletIndex += 1
        }
    }
    
    private func setupRiversideToiletMarkers() {
        mapView.clear()
        
        var riversideToiletIndex = 0
        for riversideToilet in riversideToilets {
            let  position = riversideToilet.coordinate
            let marker = GMSMarker(position: position)
            marker.iconView = getMarkerIconImage("icon-toilet")
            marker.title = "\(riversideToilet.location)"
            marker.userData = riversideToiletIndex
            marker.map = mapView
            
            riversideToiletIndex += 1
        }
    }
    
    private func setupYoubikeMarkers() {
        mapView.clear()
        //youbikes = youbikes.filter(isNearCurrentLocation)

        var youbikeIndex = 0
        for youbike in youbikes {
            let  position = youbike.coordinate
            let marker = GMSMarker(position: position)
            marker.iconView = getMarkerIconImage("icon-station")
            marker.title = "\(youbike.bikeRemain) bikes left"
            marker.userData = youbikeIndex
            marker.map = mapView
            
            youbikeIndex += 1
        }
        
    }
    
    private func setupEstimatedArrivalTimeLabel(destinationCoordinates: CLLocationCoordinate2D) -> Double {

        var EstimateArrivalTimeInMinutes = 0.0
        
        guard let currentLocation = currentLocation else { return 0 }
        let sourcePlacemark = MKPlacemark(coordinate: currentLocation.coordinate, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinates, addressDictionary: nil)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let request = MKDirectionsRequest()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = MKDirectionsTransportType.Walking
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler { response, error in
            
            guard let route = response?.routes.first else {
                print("getEstimateArrivalTime Error: \(error)")
                return
            }
            EstimateArrivalTimeInMinutes = route.expectedTravelTime / 60
            self.estimatedArrivalTimeLabel.text = "\(round(EstimateArrivalTimeInMinutes)) minutes"
        }
        return EstimateArrivalTimeInMinutes
    }
    
    private func setupCamera(cameraCenter: CLLocationCoordinate2D) {
        if didSetCamera == false {
            mapView.camera = GMSCameraPosition(target: cameraCenter, zoom: 18, bearing: 0, viewingAngle: 0)
        }
        didSetCamera = true
    }
    
    private func setupMap() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func isNearCurrentLocation(publicToilet: PublicToiletModel) -> Bool {
        
        let publicToiletCoordinateLocation = CLLocation(latitude: publicToilet.coordinate.latitude, longitude: publicToilet.coordinate.longitude)
        
        if currentLocation == nil { return false }
        let distanceInMeters = publicToiletCoordinateLocation.distanceFromLocation(currentLocation!)

        return distanceInMeters < 500
    }
    
    private func isNearCurrentLocation(youbike: YoubikeModel) -> Bool {
        
        let youbikeCoordinateLocation = CLLocation(latitude: youbike.coordinate.latitude, longitude: youbike.coordinate.longitude)
        
        if currentLocation == nil { return false }
        let distanceInMeters = youbikeCoordinateLocation.distanceFromLocation(currentLocation!)
        
        return distanceInMeters < 1500
    }


}

// MARK: - CLLocationManagerDelegate


extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            mapView.myLocationEnabled = true
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
        
        if currentLocation != nil {
            setupCamera(currentLocation!.coordinate)
        }
    }
    
}



// MARK: - Data

extension MapViewController {
    
    private func getData() {
        getPublicToiletsData()
        getRiversideToiletsData()
        getYoubikeData()
    }
    
    private func getRiversideToiletsData() {
    
        let mapDataManager = MapDataManager()
        
        mapDataManager.getRiversideToilets(
            success: { [weak self] riversideToilets in
                
                guard let weakSelf = self else { return }

                weakSelf.riversideToilets = riversideToilets
                
                //weakSelf.setupToiletMarkers()
            },
            failure: { error in
                
                print("ERROR: \(error)")
            }
        )
        
    }
    
    private func getPublicToiletsData() {
        
        let mapDataManager = MapDataManager()
        
            mapDataManager.getPublicToilets(
                success: { [weak self] publicToilets in
                    
                    guard let weakSelf = self else { return }
                    weakSelf.publicToilets = publicToilets
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
    private func setup() {
        infoView.hidden = true
        setupPickerView()
    }
}



// MARK: - View LifeCycle

extension MapViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        getData()
        setup()
        lookForButton.setTitle("Youbike", forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(true)
        setupMap()
        // need to set delegate only before using, because TrackingPage also have the same delegate.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        didSetCamera = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        mapView.delegate = nil
        locationManager.delegate = nil
        didSetCamera = false
        super.viewWillDisappear(true)
    }
    
}




// MARK: - PickerViewSetup

extension MapViewController {
    
    private func setupPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self

        pickerViewWindow.hidden = true
    }
    
    @IBAction func lookForButton(sender: UIButton) {
        pickerViewWindow.hidden = false
        infoView.hidden = true
    }
    
    @IBAction func pickerViewWindowDoneButton(sender: UIButton) {
        pickerViewWindow.hidden = true
        lookForButton.setTitle(templookForButtonText, forState: .Normal)
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
        return pickerTitle.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitle[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch row {
            case 0:
                markerStatus = .Youbikes
                setupYoubikeMarkers()
                Amplitude.instance().logEvent("select_look_for_in_youbike_map")
            case 1:
                markerStatus = .RiversideToilets
                setupRiversideToiletMarkers()
                Amplitude.instance().logEvent("select_look_for_in_riverside_toilet_map")
            case 2:
                markerStatus = .PublicToilets
                setupPublicToiletMarkers()
                Amplitude.instance().logEvent("select_look_for_in_public_toilet_map")
            default: break
        }
        
        templookForButtonText = pickerTitle[row]
    }
}



// MARK: -  Initializer

extension MapViewController {
    
    class func controller() -> MapViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
    }
}
