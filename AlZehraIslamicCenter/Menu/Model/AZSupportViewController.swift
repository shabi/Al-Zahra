//
//  AZSupportViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 28/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController

class AZSupportViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Support"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

extension AZSupportViewController: ViewController {
    
    func updateView() {}
}
