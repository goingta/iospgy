//
//  PGYViewModel.swift
//  iospgy
//
//  Created by goingta on 2018/12/10.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation
import ObjectMapper

class PGYViewModel: NSObject {
    
    //最新数据的PGY历史版本的build号
    var buildBuildVersion:Int = 0 {
        didSet{
            UserDefaults.standard.set(buildBuildVersion, forKey: userDefaultBuildBuildVersion)
        }
    }
    //完整的所有数据源
    var allListBuilds:[PGYModel] = []
    //分组版本号 如：["1.0.0","1.0.2"]
    var sectionBuildVersions:[String] = []
    //要显示的分组数据源
    var showListBuilds:[String:[PGYModel]] = [:]
    
    
    /// 获取数据源方法
    ///
    /// - Parameter callback:
    func getDataSource(_ callback:@escaping (()->Void)) {
        //先获取本地缓存数据
        buildBuildVersion = UserDefaults.standard.integer(forKey: userDefaultBuildBuildVersion)
        if let s = UserDefaults.standard.object(forKey: userDefaultAllListBuilds) as? String {
            allListBuilds = Mapper<PGYModel>().mapArray(JSONString: s) ?? []
        }
        
        //获取PGY服务器数据更新新的数据源
        self.recursiveRequest { (models) in
            self.allListBuilds.insert(contentsOf: models, at: 0)
            //重置数据源
            self.sectionBuildVersions = []
            self.showListBuilds = [:]
            for item in self.allListBuilds {
                if !self.sectionBuildVersions.contains(item.buildVersion) {
                    self.sectionBuildVersions.append(item.buildVersion)
                }
                if self.showListBuilds[item.buildVersion] == nil {
                    self.showListBuilds[item.buildVersion] = [item]
                }
                else {
                    self.showListBuilds[item.buildVersion]!.append(item)
                }
            }
            if self.allListBuilds.count > 0 {
                self.buildBuildVersion = Int(self.allListBuilds[0].buildBuildVersion)!
            }
            UserDefaults.standard.set(self.allListBuilds.toJSONString(), forKey: userDefaultAllListBuilds)
            //回调数据已准备好
            callback()
        }
    }
    
    /// jekins触发编译
    func jenkinsBuild(view: UIView){
        //这里需要替换成自己的jenkins地址
        //格式：http://{IP}:{端口号}/buildByToken/build?job={Job名称}&token={Token}
        network.jenkinsBuild(jenkinsUrlString: "http://{IP}:{端口号}/buildByToken/build?job={Job名称}&token={Token}") { [weak self] in
            guard let _self = self else { return }
            view.makeToast("触发成功！")
        }
    }
    
    //请求本地没有的数据
    fileprivate let network:PGYNetwork = PGYNetwork()
    fileprivate func recursiveRequest(page:Int = 1,callback:@escaping ((_ models:[PGYModel])->Void)){
        
        var models:[PGYModel] = []
        var needNextRequest:Bool = true
        network.getPGYList(page: page) { (netModel) in
            for item in netModel!.list {
                //新数据添加到数据源中
                if Int(item.buildBuildVersion)! > self.buildBuildVersion {
                    models.append(item)
                }
                else {
                    needNextRequest = false
                }
            }
            //判断数据是否齐全  蒲公英默认显示20条数据
            if netModel!.list.count < 20 {
                needNextRequest = false
            }
            //如果需要向下请求
            if needNextRequest {
                self.recursiveRequest(page: page+1, callback: { (recursiveModels) in
                    models.append(contentsOf: recursiveModels)
                    callback(models)
                })
            }
            else {
                callback(models)
            }
        }
        
    }
}
