//
//  InfoCell.swift
//  iospgy
//
//  Created by goingta on 2018/6/1.
//  Copyright © 2018 goingta. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var infoModel: PGYModel?
    var qcCodeCallback: ((_ tag: Any) -> Void)?
   
    func setModel(model: PGYModel) {
        infoModel = model
        titleLabel.text = "# 版本:\(model.buildVersion)(\(model.buildBuildVersion)) 时间:\(model.buildCreated)"
        descLabel.text = "# "+model.buildUpdateDescription.replacingOccurrences(of: "\n", with: "；").replacingOccurrences(of: "#", with: "")
    }
    
    @IBAction func install(_ sender: Any) {
        if let key = infoModel?.buildKey {
            let urlString = "itms-services://?action=download-manifest&url=https://www.pgyer.com/app/plist/\(key)"
            UIApplication.shared.openURL(URL.init(string: urlString)!)
        }
    }
    
    @IBAction func qrCode(_ sender: Any) {
        qcCodeCallback?(self.tag)
    }
    
    
}
