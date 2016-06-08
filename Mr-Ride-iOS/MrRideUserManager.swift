//
//  MrRideUserManager.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class MrRideUserManager {
    static let sharedManager = MrRideUserManager()
}

// MARK: - Facebook

extension MrRideUserManager {
    
    enum LogInWithFacebookError: ErrorType {
        case FacebookError(error: NSError)
        case NoResult
        case Cancelled
    }
    
    typealias LogInWithFacebookSuccess = () -> Void
    typealias LogInWithFacebookFailure = (error: ErrorType) -> Void
    
    func logInWithFacebook(fromViewController fromViewController: UIViewController, success: LogInWithFacebookSuccess, failure: LogInWithFacebookFailure?) {
        
        let facebook = MrRideFacebook()
        
        FBSDKLoginManager().logInWithReadPermissions(
            facebook.requiredReadPermissions.map { return $0.rawValue },
            fromViewController: fromViewController,
            handler: { result, fbError in
                
                if fbError != nil {
                    
                    let error: LogInWithFacebookError = .FacebookError(error: fbError)
                    failure?(error: error)
                    
                    return
                    
                }
                
                if result == nil {
                    
                    let error: LogInWithFacebookError = .NoResult
                    failure?(error: error)
                    
                    return
                    
                }
                
                if result.isCancelled {
                    
                    let error: LogInWithFacebookError = .Cancelled
                    failure?(error: error)
                    
                    return
                    
                }
                
                let permissionErrors = facebook.verifyRequiredReadPermissions(grantedPermissions: result.grantedPermissions)
                
                if let error = permissionErrors.first {
                    
                    FBSDKLoginManager().logOut()
                    failure?(error: error)
                    
                    return
                    
                }
                success()
            }
        )
    }
}
