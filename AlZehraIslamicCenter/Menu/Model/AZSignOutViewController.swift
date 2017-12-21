//
//  AZSignOutViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 28/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController

class AZSignOutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "SignOut"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}

extension AZSignOutViewController: ViewController {
    
    func updateView() {}
}
