//
//  ViewController.swift
//  iospgy
//
//  Created by goingta on 2018/6/1.
//  Copyright © 2018 goingta. All rights reserved.
//

import UIKit
import PullToRefreshKit
import Toast_Swift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let viewModel:PGYViewModel = PGYViewModel()
    
    let useQRCode = false //看自己喜好用二维码，还是直接分享给其他人
    
    var list: PGYListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        let img = UIImage.init(named: "tabbar")
        print("end")
    }
    
    func initUI() {
        tableView.register(UINib.init(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        tableView.tableFooterView = UIView()
        tableView.configRefreshHeader(container: self) { [weak self] in
            guard let _self = self else { return }
            _self.request()
        }
        tableView.switchRefreshHeader(to: .refreshing)
    }
    
    func request() {
        viewModel.getDataSource { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
        }
    }
    
    @IBAction func build(_ sender: Any) {
        viewModel.jenkinsBuild(view: self.view)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionBuildVersions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let models:[PGYModel] = viewModel.showListBuilds[viewModel.sectionBuildVersions[section]]!
        //最多显示10个
        if models.count > 10 {
            return 10
        }
        else {
            return models.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        let models:[PGYModel] = viewModel.showListBuilds[viewModel.sectionBuildVersions[indexPath.section]]!
        let model = models[indexPath.row]
        cell.setModel(model: model)

        cell.qcCodeCallback = { [weak self] (tag) in
            guard let _self = self else { return }
            if (_self.useQRCode) {
                let webVC = WKWebViewController()
                if let model = _self.list?.list[indexPath.row] {
                    webVC.setUrl(url: URL.init(string: "https://www.pgyer.com/\(model.buildKey)")!)
                    _self.navigationController?.pushViewController(webVC, animated: true)
                }
            } else {
                let ext:WXWebpageObject = WXWebpageObject.init()
                ext.webpageUrl = "https://www.pgyer.com/\(model.buildKey)"
                
                let message:WXMediaMessage = WXMediaMessage.init()
                message.title = "蒲公英iOS版本(\(model.buildVersion):\(model.buildBuildVersion))"
                message.description = model.buildUpdateDescription
                message.mediaObject = ext
                message.setThumbImage(UIImage.init(named: "logo"))
                message.mediaTagName = model.buildVersion
                
                let req:SendMessageToWXReq = SendMessageToWXReq.init()
                req.message = message
                req.bText = false
                req.scene = Int32(WXSceneSession.rawValue)
                _ = WXApi.send(req)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView:UIView = UIView.init()
        headerView.backgroundColor = UIColor.colorWithHex("4D90FE")
        let label:UILabel = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: 150, height: 28))
        label.text = viewModel.sectionBuildVersions[section]
        label.textColor = UIColor.white
        headerView.addSubview(label)
        return headerView
    }

}

