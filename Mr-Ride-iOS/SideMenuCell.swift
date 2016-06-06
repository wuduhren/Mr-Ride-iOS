//
//  SideMenuCell.swift
//  Mr-Ride-iOS
//
//  Created by Eph on 2016/5/25.
//  Copyright © 2016年 AppWorks School WuDuhRen. All rights reserved.
//

import UIKit


protocol SideMenuDelegate: class {
    func changeChildView(pageString: String)
}

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    
    weak var delegate: SideMenuDelegate?
    
    var buttonTitle = ""
}



// MARK: - Action

extension SideMenuCell {
    
    @IBAction func button(sender: UIButton) {
        delegate?.changeChildView(buttonTitle)
    }
}


// MARK: - View Lifecycle

extension SideMenuCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


// MARK: - Setup

extension SideMenuCell {
    
    func setup() {
        button.titleLabel?.font = .mrTextStyle11Font()
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitle(buttonTitle, forState: .Normal)
    }
}


