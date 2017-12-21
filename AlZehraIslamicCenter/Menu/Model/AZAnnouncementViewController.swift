//
//  AZAnnouncementViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 29/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController

class AZAnnouncementViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "Announcement"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

extension AZAnnouncementViewController: ViewController {
    
    func updateView() {}
}
