//
//  RunDataTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/6/3.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit



class RunDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    var runDataStruct: runData? = nil
    
    struct runData {
        var date: NSDate?
        var distance: Double?
        var time: String?
    }
    
    func setup() {
        date.text = "\(runDataStruct?.date)"
        distance.text = "\(runDataStruct?.distance)"
        time.text = "\(runDataStruct?.time)"
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}