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
    
    @IBAction func cancelButtonToHomePage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func setupNavigationItem() {
        cancelButtonToHomePage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font() ], forState: UIControlState.Normal)
        finishButtonToResultPage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font() ], forState: UIControlState.Normal)
        
        //title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(NSDate())
        navigationController?.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
