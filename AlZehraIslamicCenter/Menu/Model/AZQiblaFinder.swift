//
//  AZQiblaFinder.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 04/12/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import WebKit

class AZQiblaFinder: UIViewController {
    
    @IBOutlet weak var myWebView: UIWebView!
    //    @IBOutlet weak var myWebView1: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Qibla Finder"
        
        let requestObj = URLRequest(url: URL(string: "https://qiblafinder.withgoogle.com/intl/en/finder/ar")!)
        myWebView.loadRequest(requestObj)
    }
}

extension AZQiblaFinder: ViewController {
    
    func updateView() {}
}

