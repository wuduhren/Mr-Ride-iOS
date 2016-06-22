//
//  Entity+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/31.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entity {

    @NSManaged var date: NSDate?
    @NSManaged var distance: NSNumber?
    @NSManaged var speed: NSNumber?
    @NSManaged var calories: NSNumber?
    @NSManaged var time: String?
    @NSManaged var polyline: NSObject?

}
