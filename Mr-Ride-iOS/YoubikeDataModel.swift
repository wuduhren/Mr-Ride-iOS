//
//  YoubikeDataModel.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/14.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import CoreLocation

class YoubikeModel {
    
    let identifier: String
    
    let name: String
    let englishName: String
    
    let location: String
    let englishLocation: String
    
    let district: String
    let englishDistrict: String
    
    
    let coordinate: CLLocationCoordinate2D
    let bikeRemain: Int
    let updateTime: NSDate
    
    
    init(identifier: String,
         name: String, englishName: String,
         location: String, englishLocation: String,
         district: String, englishDistrict: String,
         coordinate: CLLocationCoordinate2D,
         bikeRemain: Int,
         updateTime: NSDate) {
        
        
        self.identifier = identifier
        
        self.name = name
        self.englishName = englishName
        
        self.location = location
        self.englishLocation = englishLocation
        
        self.district = district
        self.englishDistrict = englishDistrict
        
        self.coordinate = coordinate
        self.bikeRemain = bikeRemain
        self.updateTime = updateTime
    }
    
}
