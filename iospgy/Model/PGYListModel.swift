//
//  PGYListModel.swift
//  iospgy
//
//  Created by goingta on 2018/6/1.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation
import ObjectMapper

struct PGYListModel:Mappable {
    
    var list: [PGYModel] = []
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.list <- map["list"]
    }
}
