//
//  MapViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var lookForButton: UIButton!
    var templookForButtonText = ""
    
    @IBOutlet weak var pickerViewWindow: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let lookForOption = ["Toilet", "Ubike Station"]
    
    var toilets: [ToiletModel] = []
    
}



// MARK: - Data

extension MapViewController {
    
    private func getToiletsData() {
    
        let mapDataManager = MapDataManager()
        
        mapDataManager.getToilets(
            success: { [weak self] result in
                
                guard let weakSelf = self else { return }

                weakSelf.toilets = result
                
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
        print(toilets)
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
