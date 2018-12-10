//
//  MiniProgramListViewController.swift
//  iospgy
//
//  Created by goingta on 2018/12/10.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation

class MiniProgramListViewController: UITableViewController {
    
    let dataSource:[[String:String]] = [
        ["name":"个税小程序","image":"Tax.jpg","programName":weappId],
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 90
        self.navigationController?.navigationBar.topItem?.title = "小程序"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MiniprogramTableViewCell") as! MiniprogramCell
        cell.title.text = dataSource[indexPath.row]["name"]
        cell.logoImg.image = UIImage.init(named: dataSource[indexPath.row]["image"]!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if !WXApi.isWXAppInstalled() {
            self.view.makeToast("没有安装微信，无法跳转到小程序~")
            return
        }

        let launchMiniProgramReq = WXLaunchMiniProgramReq.object()
        launchMiniProgramReq?.userName = dataSource[indexPath.row]["programName"]!
        launchMiniProgramReq?.miniProgramType = .release //正式版
        WXApi.send(launchMiniProgramReq)
    }
    
}
