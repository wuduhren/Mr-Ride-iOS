//
//  MrRideFacebook.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation

struct MrRideFacebook: Facebook {
    
    var requiredReadPermissions: [FacebookPermission] { return [ .PublicProfile, .Email ] }
    
}


// MARK: - Validation

extension MrRideFacebook {
    
    enum VerifyPermissionsError: ErrorType {
        case PermissionRequired(permission: FacebookPermission)
    }
    
    func verifyPermissions(permissions: [FacebookPermission], grantedPermissions: Set<NSObject>) -> [ErrorType] {
        
        var errors: [ErrorType] = []
        
        for permission in permissions {
            
            if !grantedPermissions.contains(permission.rawValue) {
                
                let error: VerifyPermissionsError = .PermissionRequired(permission: permission)
                errors.append(error)
                
            }
            
        }
        
        return errors
        
    }
    
    func verifyRequiredReadPermissions(grantedPermissions grantedPermissions: Set<NSObject>) -> [ErrorType] { return verifyPermissions(requiredReadPermissions, grantedPermissions: grantedPermissions) }
    
}
