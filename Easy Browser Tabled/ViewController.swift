//
//  ViewController.swift
//  Easy Browser
//
//  Created by Michele Galvagno on 25/02/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Properties
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websiteToLoad: String?
    
    // MARK: - Views Managment
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar buttons setup
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "◀︎", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "▶︎", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [back, forward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // KVO setup
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        // Navigation management
        let url = URL(string: "https://" + websiteToLoad!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // MARK: - Methods
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // Decide whether the navigation is allowed or not.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            if host.contains(websiteToLoad!) {
                decisionHandler(.allow)
                
                return
            }
        }
        
        let alertController = UIAlertController(title: "WARNING!", message: "This website is blocked!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        decisionHandler(.cancel)
    }
}

