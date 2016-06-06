//
//  RunData.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/3.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation
import CoreData


class RunDataModel {
    
    class runDataStruct {
        var date: NSDate?
        var distance: Double?
        var speed: Double?
        var calories: Double?
        var time: String?
        var polyline: NSData?
    }
    
    private let context = DataController().managedObjectContext
    var runDataStructArray: [runDataStruct] = []
    
    
    func getData() -> [runDataStruct] {
        do {
            let getRequest = NSFetchRequest(entityName: "Entity")
            let sortDesriptor = NSSortDescriptor(key: "date", ascending: true)
            getRequest.sortDescriptors = [sortDesriptor]
            
            let data = try context.executeFetchRequest(getRequest)
            runDataStructArray = [] //reset
            for eachData in data {
                let tempStruct = runDataStruct()
                tempStruct.date = eachData.valueForKey("date")! as? NSDate
                tempStruct.distance = eachData.valueForKey("distance")! as? Double
                tempStruct.speed = eachData.valueForKey("speed")! as? Double
                tempStruct.calories = eachData.valueForKey("calories")! as? Double
                tempStruct.time = eachData.valueForKey("time")! as? String
                tempStruct.polyline = eachData.valueForKey("polyline")! as? NSData
                runDataStructArray.append(tempStruct)
            }
            
            return runDataStructArray
        } catch {
            fatalError("error appear when fetching")
        }
    }
   
}
