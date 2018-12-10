//
//  UIColorExtension.swift
//  iospgy
//
//  Created by goingta on 2018/12/10.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation

extension UIColor {
    //通过十六进制获取颜色
    public class func colorWithHex(_ hex: String, alpha:CGFloat = 1) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespaces).uppercased()
        let nsHexString = hexString.replacingOccurrences(of: "#", with: "") as NSString
        if nsHexString.length == 6 {
            let rString = nsHexString.substring(with: NSMakeRange(0, 2)) as String
            let gString = nsHexString.substring(with: NSMakeRange(2, 2)) as String
            let bString = nsHexString.substring(with: NSMakeRange(4, 2)) as String
            
            var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            return UIColor(red: CGFloat(r)/CGFloat(UInt8.max),
                           green: CGFloat(g)/CGFloat(UInt8.max),
                           blue: CGFloat(b)/CGFloat(UInt8.max), alpha: alpha)
        }
        return .clear
    }
}
