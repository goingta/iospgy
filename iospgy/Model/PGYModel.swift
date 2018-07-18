//
//  PGYModel.swift
//  iospgy
//
//  Created by goingta on 2018/6/1.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation
import ObjectMapper

struct PGYModel:Mappable {
    
    var buildKey:String = ""
    var buildFileSize:String = ""
    var buildVersion:String = ""
    var buildUpdateDescription:String = ""
    var buildBuildVersion:String = ""
    var buildCreated:String = ""
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        self.buildKey <- map["buildKey"]
        self.buildFileSize <- map["buildFileSize"]
        self.buildVersion <- map["buildVersion"]
        self.buildUpdateDescription <- map["buildUpdateDescription"]
        self.buildBuildVersion <- map["buildBuildVersion"]
        self.buildCreated <- map["buildCreated"]
    }
}
