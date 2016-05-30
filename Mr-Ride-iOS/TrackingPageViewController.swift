//
//  TrackingPageViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/26.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit


class TrackingPageViewController: UIViewController {
    
    @IBOutlet weak var finishButtonToResultPage: UIBarButtonItem!
    
    @IBOutlet weak var cancelButtonToHomePage: UIBarButtonItem!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var stopWatchButton: UIButton!
    
    enum buttonMode {
        case counting, notCounting
    }
    
    var buttonStatus = buttonMode.notCounting
    
    let stopwatch = Stopwatch()
    
    @IBAction func stopWatchButton(sender: UIButton) {
        
        
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            switch self.buttonStatus {
                case .counting:
                    self.stopWatchButton.transform = CGAffineTransformMakeScale(0.5, 0.5)
                    self.stopWatchButton.layer.cornerRadius = 15
                    self.stopWatchButton.clipsToBounds = true
                
                case .notCounting:
                    //self.stopWatchButton.frame.size = CGSize(width: 52, height: 52)
                    self.stopWatchButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    print(self.stopWatchButton.frame)
                    self.stopWatchButton.layer.cornerRadius = self.stopWatchButton.frame.width / 2
                    self.stopWatchButton.clipsToBounds = true
            }
        })
        
        switch buttonStatus {
            case .counting:
                stopwatch.pause()
            case .notCounting:
                NSTimer.scheduledTimerWithTimeInterval(
                    0.01,
                    target: self,
                    selector: #selector(TrackingPageViewController.updateElapsedTimeLabel(_:)),
                    userInfo: nil,
                    repeats: true
                )
                stopwatch.start()
                print("stopWatch should start")
        }
        
        if buttonStatus == .notCounting {
            buttonStatus = .counting
            
        } else {
            buttonStatus = .notCounting
            
        }


    
    }
    
    
    @IBAction func cancelButtonToHomePage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func updateElapsedTimeLabel(timer: NSTimer) {
        var totalInterval: NSTimeInterval
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
    
    func setupStopWatchButton() {
        stopWatchButton.backgroundColor = .redColor()
        self.stopWatchButton.layer.cornerRadius = self.stopWatchButton.frame.width/2
        self.stopWatchButton.clipsToBounds = true
        print("view did load: \(self.stopWatchButton.frame)")
        
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupBackground()
        setupStopWatchButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
