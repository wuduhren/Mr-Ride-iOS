//
//  MapDataRouter.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//  Reference: YBManager.swift Created by 許郁棋 on 2016/4/27.
//

import Alamofire
import SwiftyJSON

class MapDataManager {
    
    static let sharedManager = MapDataManager()
    
}



// MARK: - Toilets

extension MapDataManager {
    
    typealias GetToiletsSuccess = (toilets: [ToiletModel]) -> Void
    typealias GetToiletsFailure = (error: ErrorType) -> Void
    
    enum GetToiletsError: ErrorType { case Server(message: String) }
    
    func getToilets(success success: GetToiletsSuccess, failure: GetToiletsFailure?) -> Request {
        
        let URLRequest = MapDataRouter.GetToilets
        let request = Alamofire.request(URLRequest).validate().responseData { result in

            if let statusCode = result.response?.statusCode {
                //print("getToilets statusCode: \(statusCode)")
            }
            
            switch result.result {
            
            case .Success(let data):

                let json = JSON(data: data)
                
                var toilets: [ToiletModel] = []
                
                for (_, subJSON) in json["result"]["results"] {
                    
                    do {
                        let toilet = try ToiletModelHelper().parse(json: subJSON)
                        toilets.append(toilet)
                    }
                    catch(let error) { print("ERROR: \(error)") }
                    
                }
                
                success(toilets: toilets)
                
            case .Failure(let err):
                
                let error: GetToiletsError = .Server(message: err.localizedDescription)
                print("ERROR: \(error)")
                
                failure?(error: error)
                
            }
            
        }
        
        return request
        
    }
}



// MARK: - Toilets

extension MapDataManager {
    
    typealias GetYoubikeSuccess = (youbikes: [YoubikeModel]) -> Void
    typealias GetYoubikeFailure = (error: ErrorType) -> Void
    
    enum GetYoubikeError: ErrorType { case Server(message: String) }
    
    func getYoubikes(success success: GetYoubikeSuccess, failure: GetYoubikeFailure?) -> Request {
        
        let URLRequest = MapDataRouter.GetYoubike
        let request = Alamofire.request(URLRequest).validate().responseData { result in
            
            if let statusCode = result.response?.statusCode {
                //print("getYoubike statusCode: \(statusCode)")
            }
            
            switch result.result {
                
            case .Success(let data):
                
                let json = JSON(data: data)
                
                var youbikes: [YoubikeModel] = []
                
                for (_, subJSON) in json["retVal"] {
                    
                    do {
                        let youbike = try YoubikeModelHelper().parse(json: subJSON)
                        youbikes.append(youbike)
                    }
                    catch(let error) { print("ERROR: \(error)") }
                }
                success(youbikes: youbikes)
                
            case .Failure(let err):
                
                let error: GetToiletsError = .Server(message: err.localizedDescription)
                print("ERROR: \(error)")
                
                failure?(error: error)
                
            }
        }
        return request
    }
    
    
}

