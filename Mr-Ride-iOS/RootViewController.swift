//
//  RootViewController.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/24.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit
import SideMenu
import PureLayout


class RootViewController: UIViewController {
    
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
    
    private lazy var mapViewController: MapViewController = { [unowned self] in
        let mapViewController = MapViewController.controller()
        self.addChildViewController(mapViewController)
        self.didMoveToParentViewController(mapViewController)
        return mapViewController
        }()
    
    deinit {
        print("RootViewController released")
    }
    
}



// MARK: - SideMenuDelegate

extension RootViewController: SideMenuDelegate {
    
    func changeChildView(pageString: String){
        
        clearView()
        
        switch pageString {
            
        case "Home":
            setupHomeViewController()
        case "History":
            setupHistoryViewController()
        case "Map":
            setupMapViewController()
        default: break
            
        }
    }
    
    private func clearView() {
        
        homeViewController.view.removeFromSuperview()
        historyViewController.view.removeFromSuperview()
        mapViewController.view.removeFromSuperview()
        sideMenuNavigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.navigationItem.titleView = nil
    }
}



// MARK: - Setup

extension RootViewController {
    
    private func setupHomeViewController() {
        view.addSubview(homeViewController.view)
        homeViewController.view.autoPinEdgesToSuperviewEdges()
        
        let bikeIconImageView = UIImageView(image:UIImage(named: "icon-bike.png"))
        bikeIconImageView.image = bikeIconImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        bikeIconImageView.tintColor = .whiteColor()
        self.navigationItem.titleView = bikeIconImageView
    }
    
    private func setupHistoryViewController() {
        view.addSubview(historyViewController.view)
        historyViewController.view.autoPinEdgesToSuperviewEdges()
        
        self.navigationItem.title = "History"
        navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    private func setupMapViewController() {
        view.addSubview(mapViewController.view)
        mapViewController.view.autoPinEdgesToSuperviewEdges()
        
        self.navigationItem.title = "Map"
        navigationController!.navigationBar.titleTextAttributes =
            ([NSFontAttributeName: UIFont.mrTextStyle13Font(),
                NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    private func setup() {
        setupHomeViewController()
        
        //navigationBorderHidden
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        SideMenuManager.menuFadeStatusBar = false
        self.edgesForExtendedLayout = UIRectEdge.None
    }
}



// MARK: - View LifeCycle

extension RootViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //print("RootViewController: \(self)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SideMenuNavigationController") {
            sideMenuNavigationController = (segue.destinationViewController as? UISideMenuNavigationController)!
        }
        (sideMenuNavigationController?.viewControllers[0] as? SideMenuTableViewController)?.delegate = self
    }
    
}



// MARK: -  Initializer

extension RootViewController {
    //return RootViewController's NavigationController
    class func controller() -> UINavigationController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootViewNavigationController") as! UINavigationController
    }
}




