//
//  Facebook.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation

enum FacebookPermission: String {
    case PublicProfile = "public_profile"
    case Email = "email"
}

protocol Facebook {
    
    var requiredReadPermissions: [FacebookPermission] { get }
    
}