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



// MARK: - PublicToilets

extension MapDataManager {
    
    typealias GetPublicToiletsSuccess = (riversideToilets: [PublicToiletModel]) -> Void
    typealias GetPublicToiletsFailure = (error: ErrorType) -> Void
    
    enum GetPublicToiletsError: ErrorType { case Server(message: String) }
    
    func getPublicToilets(success success: GetPublicToiletsSuccess, failure: GetPublicToiletsFailure?) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0) ){
        
            let URLRequest = MapDataRouter.GetPublicToilets
            let request = Alamofire.request(URLRequest).validate().responseData { result in
                
                if let statusCode = result.response?.statusCode {
                    //print("getPublicToilets statusCode: \(statusCode)")
                }
                
                switch result.result {
                    
                case .Success(let data):
                    
                    let json = JSON(data: data)
                    
                    var publicToilets: [PublicToiletModel] = []
                    
                    for (_, subJSON) in json["result"]["results"] {
                        
                        do {
                            let publicToilet = try PublicToiletModelHelper().parse(json: subJSON)
                            publicToilets.append(publicToilet)
                        }
                        catch(let error) { print("ERROR: \(error)") }
                        
                    }
                    
                    success(riversideToilets: publicToilets)
                    
                case .Failure(let err):
                    
                    let error: GetPublicToiletsError = .Server(message: err.localizedDescription)
                    print("ERROR: \(error)")
                    
                    failure?(error: error)
                }
            }
        }
    }
}




// MARK: - RiversideToilets

extension MapDataManager {
    
    typealias GetRiversideToiletsSuccess = (riversideToilets: [RiversideToiletModel]) -> Void
    typealias GetRiversideToiletsFailure = (error: ErrorType) -> Void
    
    enum GetRiversideToiletsError: ErrorType { case Server(message: String) }
    
    func getRiversideToilets(success success: GetRiversideToiletsSuccess, failure: GetRiversideToiletsFailure?) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0) ){
        
            let URLRequest = MapDataRouter.GetRiverSideToilets
            let request = Alamofire.request(URLRequest).validate().responseData { result in

                if let statusCode = result.response?.statusCode {
                    //print("RiversideToilets statusCode: \(statusCode)")
                }
                
                switch result.result {
                
                case .Success(let data):

                    let json = JSON(data: data)
                    
                    var riversideToilets: [RiversideToiletModel] = []
                    
                    for (_, subJSON) in json["result"]["results"] {
                        
                        do {
                            let riversideToilet = try RiversideToiletModelHelper().parse(json: subJSON)
                            riversideToilets.append(riversideToilet)
                        }
                        catch(let error) { print("ERROR: \(error)") }
                        
                    }
                    
                    success(riversideToilets: riversideToilets)
                    
                case .Failure(let err):
                    
                    let error: GetRiversideToiletsError = .Server(message: err.localizedDescription)
                    print("ERROR: \(error)")
                    
                    failure?(error: error)
                    
                }
                
            }
        }
    }
}



// MARK: - Youbike

extension MapDataManager {
    
    typealias GetYoubikeSuccess = (youbikes: [YoubikeModel]) -> Void
    typealias GetYoubikeFailure = (error: ErrorType) -> Void
    
    enum GetYoubikeError: ErrorType { case Server(message: String) }
    
    func getYoubikes(success success: GetYoubikeSuccess, failure: GetYoubikeFailure?) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0) ){
        
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
                    
                    let error: GetYoubikeError = .Server(message: err.localizedDescription)
                    print("ERROR: \(error)")
                    
                    failure?(error: error)
                }
            }
        }
    }
    
    
}

