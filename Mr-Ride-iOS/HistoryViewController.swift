//
//  HistoryViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/25.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    class func controller() -> HistoryViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HistoryViewController") as! HistoryViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .MRLightblueColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
