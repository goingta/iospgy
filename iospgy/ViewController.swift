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
    
    let network = PGYNetwork()
    
    var list: PGYListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        tableView.switchRefreshHeader(to: .refreshing)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initUI() {
        tableView.register(UINib.init(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "infoCell")
        tableView.tableFooterView = UIView()
        tableView.configRefreshHeader(container: self) { [weak self] in
            guard let _self = self else { return }
            _self.request()
        }
    }
    
    func request() {
        network.getPGYList { [weak self] (model) in
            guard let _self = self else { return }
            _self.tableView.switchRefreshHeader(to: .normal(.success, 0.5))
            _self.list = model
            _self.tableView.reloadData()
        }
    }
    
    @IBAction func build(_ sender: Any) {
        //这里需要替换成自己的jenkins地址
        //格式：http://{IP}:{端口号}/buildByToken/build?job={Job名称}&token={Token}
        network.jenkinsBuild(jenkinsUrlString: "http://{IP}:{端口号}/buildByToken/build?job={Job名称}&token={Token}") { [weak self] in
            guard let _self = self else { return }
            _self.view.makeToast("触发成功！")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoCell
        if let model = list?.list[indexPath.row] {
            cell.setModel(model: model)
        }
        cell.qcCodeCallback = { [weak self] (tag) in
            guard let _self = self else { return }
            let webVC = WKWebViewController()
            if let model = _self.list?.list[indexPath.row] {
                webVC.setUrl(url: URL.init(string: "https://www.pgyer.com/\(model.buildKey)")!)
                _self.navigationController?.pushViewController(webVC, animated: true)
            }
        }
        cell.selectionStyle = .none
        return cell
    }

}

