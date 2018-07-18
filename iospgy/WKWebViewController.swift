//
//  WKWebViewController.swift
//  iospgy
//
//  Created by goingta on 2018/6/2.
//  Copyright © 2018 goingta. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    var wkWebView = WKWebView()
    var activityIndicator = UIActivityIndicatorView()
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if let requestURL = url {
            let request = URLRequest.init(url: requestURL)
            wkWebView.load(request)
        }
    }
    
    private func setupUI() {
        wkWebView.frame = self.view.bounds
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        view.addSubview(wkWebView)
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func setUrl(url: URL) {
        self.url = url
    }
}

extension WKWebViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
