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
    
    @IBAction func button(sender: UIButton) {
        delegate?.changeChildView(buttonTitle)
    }
    
    weak var delegate: SideMenuDelegate?
    
    var buttonTitle = ""
    
    func setup() {
        button.titleLabel?.font = .mrTextStyle11Font()
        button.setTitleColor(.whiteColor(), forState: .Normal)
        button.setTitle(buttonTitle, forState: .Normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
