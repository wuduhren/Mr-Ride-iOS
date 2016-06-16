//
//  YoubikeModelHelper.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/14.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import CoreLocation
import SwiftyJSON

struct YoubikeModelHelper { }


// MARK: - JSONParsable

extension YoubikeModelHelper {
    
    struct JSONKey {
        
        static let Identifier = "sno"
        
        static let Name = "sna"
        static let EnglishName = "snaen"
        
        static let Location = "ar"
        static let EnglishLocation = "aren"
        
        static let District = "sarea"
        static let EnglishDistrict = "sareaen"
        
        static let Latitude = "lat"
        static let Longitude = "lng"
        static let BikeRemain = "sbi"
        static let UpdateTime = "mday"
    }
    
    enum JSONError: ErrorType {
        
        case MissingIdentifier,
        
        MissingName,
        MissingEnglishName,
        
        MissingLocation,
        MissingEnglishLocation,
        
        MissingDistrict,
        MissingEnglishDistrict,
        
        MissingLatitude,
        MissingLongitude,
        MissingBikeRemain,
        MissingUpdateTime
    }
    
    func parse(json json: JSON) throws -> YoubikeModel {
        
        let numberFormatter = NSNumberFormatter()
        
        guard let identifier = json[JSONKey.Identifier].string else { throw JSONError.MissingIdentifier }
        
        guard let name = json[JSONKey.Name].string else { throw JSONError.MissingName }
    
        guard let englishName = json[JSONKey.EnglishName].string else { throw JSONError.MissingEnglishName }
        
        
        guard let location = json[JSONKey.Location].string else { throw JSONError.MissingLocation }
        
        guard let englishLocation = json[JSONKey.EnglishLocation].string else { throw JSONError.MissingEnglishLocation }
        
        
        guard let district = json[JSONKey.District].string else { throw JSONError.MissingDistrict }
        
        guard let englishDistrict = json[JSONKey.EnglishDistrict].string else { throw JSONError.MissingEnglishDistrict }
        
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0

        
        
        guard let bikeRemainString = json[JSONKey.BikeRemain].string else { throw JSONError.MissingBikeRemain }
        let bikeRemain = numberFormatter.numberFromString(bikeRemainString) as? Int ?? 0
        
        
        guard let updateTimeString = json[JSONKey.UpdateTime].string else { throw JSONError.MissingUpdateTime }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let updateTime = dateFormatter.dateFromString(updateTimeString) as NSDate? ?? NSDate()
        
        
        
        let youbike = YoubikeModel (
            identifier: identifier,
            name: name,
            englishName: englishName,
            location: location,
            englishLocation: englishLocation,
            district: district,
            englishDistrict: englishDistrict,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            bikeRemain: bikeRemain,
            updateTime: updateTime
        )
        
        return youbike
    }

    
    

}