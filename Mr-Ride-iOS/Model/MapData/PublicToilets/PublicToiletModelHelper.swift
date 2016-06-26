//
//  PublicToiletModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/24.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct PublicToiletModelHelper { }


extension PublicToiletModelHelper {
    
    struct JSONKey {
        
        static let Identifier = "_id"
        
        static let Name = "單位名稱"
        
        static let Location = "地址"
        
        static let District = "行政區"
        
        static let Longitude = "經度"
        static let Latitude = "緯度"
        
        static let forTheDisabled = "場所提供行動不便者使用廁所"
    }
    
    enum JSONError: ErrorType {
        
        case MissingIdentifier,
        
        MissingName,
        
        MissingLocation,
        
        MissingDistrict,
        
        MissingLatitude,
        MissingLongitude,
        
        MissingForTheDisabled

    }
    
    func parse(json json: JSON) throws -> PublicToiletModel {
        
        let numberFormatter = NSNumberFormatter()
        
        guard let identifier = json[JSONKey.Identifier].string else { throw JSONError.MissingIdentifier }
        
        guard let name = json[JSONKey.Name].string else { throw JSONError.MissingName }
        
        guard let location = json[JSONKey.Location].string else { throw JSONError.MissingLocation }
        
        guard let district = json[JSONKey.District].string else { throw JSONError.MissingDistrict }
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0
        
        var forTheDisabled = false
        guard let forTheDisabledString = json[JSONKey.forTheDisabled].string else { throw JSONError.MissingForTheDisabled }
        if forTheDisabledString == "v" {
            forTheDisabled = true
        } else {
            forTheDisabled = false
        }

        let publicToilet = PublicToiletModel (
            identifier: identifier,
            name: name,
            location: location,
            district: district,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            forTheDisabled: forTheDisabled
        )
        
        return publicToilet
    }
    
    
    
    
}