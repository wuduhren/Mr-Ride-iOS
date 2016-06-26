//
//  PublicToiletModel.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/24.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//
import CoreLocation

class PublicToiletModel {
    
    let identifier: String
    
    let name: String
    
    let location: String
    
    let district: String
    
    let coordinate: CLLocationCoordinate2D
    
    let forTheDisabled: Bool
    

    init(identifier: String,
         name: String,
         location: String,
         district: String,
         coordinate: CLLocationCoordinate2D,
         forTheDisabled: Bool
        ) {
        
        
        self.identifier = identifier
        
        self.name = name
        
        self.location = location
        
        self.district = district
        
        self.coordinate = coordinate
        
        self.forTheDisabled = forTheDisabled
    }
    
}