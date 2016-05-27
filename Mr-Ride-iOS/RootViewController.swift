//
//  RootViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/24.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import SideMenu



class RootViewController: UIViewController, SideMenuDelegate {
    
    var sideMenuNavigationController: UISideMenuNavigationController?
    
    
    
    
    private lazy var homeViewController: HomeViewController = { [unowned self] in
        let homeViewController = HomeViewController.controller()
        self.addChildViewController(homeViewController)
        self.didMoveToParentViewController(homeViewController)
        return homeViewController
        }()
    
    private lazy var historyViewController: HistoryViewController = { [unowned self] in
        let historyViewController = HistoryViewController.controller()
        self.addChildViewController(historyViewController)
        self.didMoveToParentViewController(historyViewController)
        return historyViewController
        }()
    
    func changeChildView(pageString: String){
        
        homeViewController.view.removeFromSuperview()
        historyViewController.view.removeFromSuperview()
        sideMenuNavigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationItem.titleView = nil
        
        switch pageString {
        case "Home":
            setupHomeViewController()
        case "History":
            setupHistoryViewController()
        default: break
        }
    }
    
    func setupHistoryViewController() {
        view.addSubview(historyViewController.view)
        self.navigationItem.title = "History"
        navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func setupHomeViewController() {
        let bikeIconImageView = UIImageView(image:UIImage(named: "icon-bike.png"))
        bikeIconImageView.image = bikeIconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        bikeIconImageView.tintColor = .whiteColor()
        self.navigationItem.titleView = bikeIconImageView
        view.addSubview(homeViewController.view)
    }
    
    func setup() {
        setupHomeViewController()
        
        //navigationBorderHidden
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        SideMenuManager.menuFadeStatusBar = false
        self.edgesForExtendedLayout = UIRectEdge.None
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SideMenuNavigationController") {
            sideMenuNavigationController = (segue.destinationViewController as? UISideMenuNavigationController)!
        }
        (sideMenuNavigationController?.viewControllers[0] as? SideMenuTableViewController)?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
