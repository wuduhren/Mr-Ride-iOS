//
//  ToiletDataModel.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import CoreLocation

class ToiletModel {
    
    let identifier: String
    let coordinate: CLLocationCoordinate2D
    let location: String
 
    init(identifier: String,location: String, coordinate: CLLocationCoordinate2D) {
        
        self.identifier = identifier
        self.coordinate = coordinate
        self.location = location
    }
    
}
