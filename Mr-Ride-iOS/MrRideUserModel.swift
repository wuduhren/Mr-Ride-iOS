//
//  MrRideUserModel.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/8.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation

import Foundation

class MrRideUserModel {
    
    let identifier: String
    var name: String
    var email: String?
    var profileImageURL: NSURL?
    var facebookURL: NSURL?
    
    init(identifier: String, name: String) {
        
        self.identifier = identifier
        self.name = name
        
    }
    
}
