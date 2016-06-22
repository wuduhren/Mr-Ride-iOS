//
//  RootViewManager.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/21.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation

class RootViewManager {
    
    static let sharedManager = RootViewManager()
    
    typealias ChangeRootViewControllerSuccess = () -> Void
    typealias ChangeRootViewControllerFailure = (error: ErrorType) -> Void
    
    enum ChangeRootViewControllerError: ErrorType {
        case NoWindow
    }
    
    func changeRootViewController(viewController viewController: UIViewController, animated: Bool, success: ChangeRootViewControllerSuccess?, failure: ChangeRootViewControllerFailure?) {
        
        if let window = UIApplication.sharedApplication().delegate?.window {
            
            if animated {
                
                if let currentRootViewController = window?.rootViewController {
                    
                    let snapshotView = currentRootViewController.view.snapshotViewAfterScreenUpdates(true)
                    viewController.view.addSubview(snapshotView)
                    window?.rootViewController = viewController
                    
                    UIView.animateWithDuration(
                        1.0,
                        animations: { snapshotView.layer.opacity = 0.0 },
                        completion: { _ in
                            snapshotView.removeFromSuperview()
                            success?()
                        }
                    )
                    
                }
                else {
                    window?.rootViewController = viewController
                    success?()
                }
                
            }
            else {
                window?.rootViewController = viewController
                success?()
            }
            
        }
        else {
            let error: ChangeRootViewControllerError = .NoWindow
            failure?(error: error)
        }
        
    }
}
