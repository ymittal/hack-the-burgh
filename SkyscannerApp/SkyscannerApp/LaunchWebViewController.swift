//
//  LaunchWebViewController.swift
//  SkyscannerApp
//
//  Created by Jennie  Chen on 3/11/18.
//  Copyright © 2018 Jennie Chen. All rights reserved.
//

import UIKit
import WebKit


class LaunchWebViewController : UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        if let url = URL(string: "https://www.skyscanner.net/") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
}

