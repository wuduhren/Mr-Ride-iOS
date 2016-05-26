//
//  RootTableViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/24.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit

class SideMenuTableViewController: UITableViewController {

    let menu = ["Home", "History"]
    
    var delegate: SideMenuDelegate?
    
    func setup() {
        self.navigationController?.navigationBarHidden = true
        self.tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        self.view.backgroundColor = .MRDarkSlateBlueColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuCell", forIndexPath: indexPath) as! SideMenuCell
        cell.delegate = delegate
        cell.buttonTitle = menu[indexPath.row]
        cell.selectionStyle = .None
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 45
    }
    
    
    
}
