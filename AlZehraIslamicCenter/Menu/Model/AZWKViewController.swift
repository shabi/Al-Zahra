//
//  AZWKViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 02/12/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import WebKit

class AZWKViewController: UIViewController {
    
    @IBOutlet weak var myWebView: UIWebView!
//    @IBOutlet weak var myWebView1: WKWebView!
    var urlStr: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Contact Detail"
        
        let requestObj = URLRequest(url: URL(string: self.urlStr!)!)
        myWebView.loadRequest(requestObj)
    }
}

extension AZWKViewController: ViewController {
    
    func updateView() {}
}

