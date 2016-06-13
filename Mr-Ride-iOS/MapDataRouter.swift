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
}


// MARK: - URLRequestConvertible

extension MapDataRouter: URLRequestConvertible {
    
    var baseURLString: String { return "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=" }
    
    var method: Alamofire.Method {
        
        switch self {
        case .GetToilets: return .GET
        }
        
    }
    
    var path: String {
        
        switch self {
        case .GetToilets: return "fe49c753-9358-49dd-8235-1fcadf5bfd3f"
        }
        
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = NSURL(string: baseURLString)!.URLByAppendingPathComponent(path)
        let URLRequest = NSMutableURLRequest(URL: URL)
        
        URLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .GetToilets: return URLRequest

        }
        
    }

    
}
