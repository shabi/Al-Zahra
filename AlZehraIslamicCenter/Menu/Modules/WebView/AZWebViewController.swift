//
//  AZWebViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 26/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import UIKit

class AZWebViewController : UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var deepWebView: UIWebView!
    var deepLinkUrl: String = ""
    var session: URLSession?
    var isWithCache: Bool = false
    var fileName: String = "test.pdf"
    var navTitle: String = " "
    var showTabBar: Bool = true
    
    //Paypal Analytics State
    fileprivate var nextURL : URL?
    fileprivate var prevURL : URL?
    fileprivate var stepCount = 0
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isWithCache, let url = URL(string: deepLinkUrl) {
            self.deepWebView?.loadRequest(URLRequest(url: url))
        }
        if isWithCache {
            fileName = deepLinkUrl.components(separatedBy: "/").last ?? "test.pdf"
            self.webviewLoadWithCacheData(urlString: deepLinkUrl)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func webviewLoadWithCacheData(urlString: String) {
        
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pdfFilePath = documentDir.appendingPathComponent(self.fileName)
            if FileManager.default.fileExists(atPath: pdfFilePath.path) {
                let request = URLRequest(url: pdfFilePath)
                self.deepWebView?.loadRequest(request)
            } else {
                if let url = URL(string: urlString) {
                    self.loadingIndicator.startAnimating()
                    let downloadTask = self.session?.downloadTask(with: URLRequest(url: url))
                    downloadTask?.resume()
                }
            }
        } else {
            if let url = URL(string: urlString) {
                self.loadingIndicator.startAnimating()
                let downloadTask = self.session?.downloadTask(with: URLRequest(url: url))
                downloadTask?.resume()
            }
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.loadingIndicator.isHidden = true
        self.loadingIndicator.stopAnimating()
        
    }
}

extension AZWebViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pdfFilePath = documentDir.appendingPathComponent(self.fileName)
            do {
                try FileManager.default.moveItem(at: location, to: pdfFilePath)
                self.deepWebView?.loadRequest(URLRequest(url: pdfFilePath))
            } catch {
                
            }
        }
    }
}

