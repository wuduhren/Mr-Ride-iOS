//
//  ViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/23.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    class func controller() -> HomeViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    }
    
    @IBOutlet weak var letsRideButton: UIButton!
    
    @IBAction func letsRideButton(sender: UIButton) {
        let trackingPagese = self.storyboard?.instantiateViewControllerWithIdentifier("TrackingPageNavigationBar") as! UINavigationController
        self.presentViewController(trackingPagese, animated: true, completion: nil)
 
    }

    func setupLetsRideButton() {
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLetsRideButton()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

