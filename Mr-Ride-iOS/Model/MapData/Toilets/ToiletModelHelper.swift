//
//  MrRideToiletModel.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//


import CoreLocation
import SwiftyJSON

struct ToiletModelHelper { }


// MARK: - JSONParsable

extension ToiletModelHelper {
    
    struct JSONKey {
        static let Identifier = "_id"
        static let Location = "Location"
        static let Latitude = "Latitude"
        static let Longitude = "Longitude"
    }
    
    enum JSONError: ErrorType { case MissingIdentifier, MissingLatitude, MissingLongitude, MissingLocation }
    
    
    func parse(json json: JSON) throws -> ToiletModel {

        guard let identifier = json[JSONKey.Identifier].string else { throw JSONError.MissingIdentifier }
        
        guard let location = json[JSONKey.Location].string else { throw JSONError.MissingLocation }
        
        
        let numberFormatter = NSNumberFormatter()
        
        guard let latitudeString = json[JSONKey.Latitude].string else { throw JSONError.MissingLatitude }
        let latitude = numberFormatter.numberFromString(latitudeString) as? Double ?? 0.0
        
        guard let longitudeString = json[JSONKey.Longitude].string else { throw JSONError.MissingLongitude }
        let longitude = numberFormatter.numberFromString(longitudeString) as? Double ?? 0.0

        
        let toilet = ToiletModel (
            identifier: identifier,
            location: location,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
        )
        
        return toilet
    }
    
    
    
    
    
    
    

}

