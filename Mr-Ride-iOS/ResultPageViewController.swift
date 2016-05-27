//
//  ResultPageViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/27.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit

class ResultPageViewController: UIViewController {

    @IBOutlet weak var closeButtonToHomePage: UIBarButtonItem!
    
    @IBAction func closeButtonToHomePage(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func setupNavigationItem() {
        closeButtonToHomePage.setTitleTextAttributes([ NSFontAttributeName: UIFont.mrTextStyle13Font(),
            NSForegroundColorAttributeName: UIColor.whiteColor() ], forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
