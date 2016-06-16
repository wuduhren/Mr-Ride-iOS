//
//  MapDataRouter.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/13.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//  Reference: YBRouter.swift Created by 許郁棋 on 2016/4/27.
//

import Alamofire
import JWT

enum MapDataRouter {
    case GetToilets
    case GetYoubike
}


// MARK: - URLRequestConvertible

extension MapDataRouter: URLRequestConvertible {
    
    var method: Alamofire.Method {
        
        switch self {
            case .GetToilets: return .GET
            case .GetYoubike: return .GET
        }
        
    }
    
    var url: NSURL {
        
        switch self {
            case .GetToilets: return NSURL(string: "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=fe49c753-9358-49dd-8235-1fcadf5bfd3f")!
            case .GetYoubike: return NSURL(string: "http://data.taipei/youbike")!
        }
        
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URLRequest = NSMutableURLRequest(URL: url)
        
        URLRequest.HTTPMethod = method.rawValue
        
        return URLRequest
        
    }

    
}
