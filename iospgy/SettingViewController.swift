//
//  SettingViewController.swift
//  iospgy
//
//  Created by goingta on 2018/6/4.
//  Copyright © 2018 goingta. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = ["已是最新版本","二维码","by goingta"]
    
    var newVersionURL: URL?
    var lastBuild: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        checkVersion()
    }
    
    func initUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    func checkVersion() {
        PgyManager.shared().isFeedbackEnabled = false
        PgyManager.shared().start(withAppId: pgyerAppKey)
        PgyUpdateManager.sharedPgy().start(withAppId: pgyerAppKey)
        PgyUpdateManager.sharedPgy().checkUpdate(withDelegete: self, selector: #selector(updateNewVersionMethod(response:)))
    }
    
    @objc func updateNewVersionMethod(response: Dictionary<String, Any>) {
        if let urlString = response["downloadURL"] as? String {
            newVersionURL = NSURL(string: urlString)! as URL
            
            if let version = response["versionName"] as? String,
                let build = response["build"] as? String {
                
                let lastBuildString = UserDefaults.standard.string(forKey: "lastBuild") ?? "0"
                self.lastBuild = build
                
                if Double(lastBuildString)! < Double(build)! {
                    let indexPath = IndexPath.init(row: 0, section: 0)
                    let cell = tableView.cellForRow(at: indexPath)
                    cell?.textLabel?.text = "下载最新版本 \(version)(\(build))"
                }
            }
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0  {
            installNewVersion()
        } else if indexPath.row == 1 {
            let webVC = WKWebViewController()
            webVC.setUrl(url: URL.init(string: "https://www.pgyer.com/nloX")!)
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func installNewVersion() {
        if let url = newVersionURL {
            UserDefaults.standard.set(self.lastBuild, forKey: "lastBuild")
            UserDefaults.standard.synchronize()
            UIApplication.shared.openURL(url)
        }
    }
    
}
