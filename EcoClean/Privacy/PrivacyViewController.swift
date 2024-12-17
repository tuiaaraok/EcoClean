//
//  PrivacyViewController.swift
//  EcoClean
//
//  Created by Karen Khachatryan on 16.12.24.
//


import UIKit
import WebKit

class PrivacyViewController: UIViewController {
    private var webView: WKWebView!
    private let urlString = "https://docs.google.com/document/d/1ItBbCCGgpLDc3Aqyy5x6GNSEtDqqxpvwCswfJw4NR00/mobilebasic"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: self.view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(webView)
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
