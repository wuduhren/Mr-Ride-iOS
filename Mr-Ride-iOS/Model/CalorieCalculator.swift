//
//  CalorieCalculator.swift
//  Mr-Ride
//
//  Created by howard hsien on 2016/5/30.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation

class CalorieCalculator {
    
    private var kCalPerKm_Hour : Dictionary <Exercise,Double> = [
        .Bike : 0.4
    ]
    
    enum Exercise {
        case Bike
    }
    
    // unit
    // speed : km/h
    // weight: kg
    // time: hr
    // return : kcal
    func kiloCalorieBurned(exerciseType: Exercise, speed: Double, weight: Double, time:Double) -> Double{
        if let kCalUnit = kCalPerKm_Hour[exerciseType]{
            return speed * weight * time * kCalUnit
        }
        else{
            return 0.0
        }
    }
}