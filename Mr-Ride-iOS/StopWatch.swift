//
//  StopWatch.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/29.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import Foundation

class Stopwatch {
    init() { }
    
    private var startTime: NSDate?
    
    var intervalBeforPause: NSTimeInterval?
    
    var elapsedTimeLabelText: String = ""
    
    var elapsedTime: NSTimeInterval {
        if let startTime = self.startTime {
            return -startTime.timeIntervalSinceNow
        } else {
            return 0
        }
    }
    
    var isRunning: Bool {
        return startTime != nil
    }
    
    func start() {
        startTime = NSDate()
    }
    
    func stop() {
        elapsedTimeLabelText = "00:00:00.00"
        intervalBeforPause = nil
        startTime = nil
    }
    
    func pause() {
        if intervalBeforPause != nil {
            intervalBeforPause = elapsedTime + intervalBeforPause!
        } else {
            intervalBeforPause = elapsedTime
        }
        
        startTime = nil
        
    }
    
}