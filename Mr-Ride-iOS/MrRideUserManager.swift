//
//  MrRideUserManager.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation
import FBSDKLoginKit

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
    
    typealias LogInWithFacebookSuccess = (user: MrRideUserModel) -> Void
    typealias LogInWithFacebookFailure = (error: ErrorType) -> Void
    
    func logInWithFacebook(fromViewController fromViewController: UIViewController, success: LogInWithFacebookSuccess, failure: LogInWithFacebookFailure?) {
        
        let facebook = MrRideFacebook()
        
        FBSDKLoginManager().logInWithReadPermissions(
            facebook.requiredReadPermissions.map { return $0.rawValue },
            fromViewController: fromViewController,
            handler: { [unowned self] result, fbError in
                
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
                
                self.getFacebookProfile(
                    success: { json in
                        
                        do {
                            
                            let user = try YBUserModelHelper().parse(json: json)
                            self.user = user
                            
                            success(user: user)
                            
                        }
                        catch(let error) {
                            
                            FBSDKLoginManager().logOut()
                            
                            failure?(error: error)
                            
                        }
                        
                    },
                    failure: { error in
                        
                        FBSDKLoginManager().logOut()
                        
                        failure?(error: error)
                        
                    }
                )
                
            }
        )
        
    }
    
    enum GetFacebookProfileError: ErrorType {
        case FacebookError(error: NSError)
        case NoAccessToken
    }
    
    typealias GetFacebookProfileSuccess = (json: JSON) -> Void
    typealias GetFacebookProfileFailure = (error: ErrorType) -> Void
    
    func getFacebookProfile(success success: GetFacebookProfileSuccess, failure: GetFacebookProfileFailure?) {
        
        guard let _ = FBSDKAccessToken.currentAccessToken() else {
            
            FBSDKLoginManager().logOut()
            
            let error: GetFacebookProfileError = .NoAccessToken
            
            failure?(error: error)
            
            return
            
        }
        
        FBSDKGraphRequest(
            graphPath: "me",
            parameters: [ "fields": "name, picture.type(large), link, email" ]
            )
            .startWithCompletionHandler { _, result, fbError in
                
                if fbError != nil {
                    
                    let error: GetFacebookProfileError = .FacebookError(error: fbError)
                    failure?(error: error)
                    
                    return
                    
                }
                
                success(json: JSON(result))
                
        }
        
    }
    
}
