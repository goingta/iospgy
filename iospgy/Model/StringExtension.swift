//
//  StringExtension.swift
//  iospgy
//
//  Created by goingta on 2018/6/1.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation

extension String {
    // 1 返回字数
    var count: Int {
        let string_NS = self as NSString
        return string_NS.length
    }
    
    //使用正则表达式替换
    func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
}
