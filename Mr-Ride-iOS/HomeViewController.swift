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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

