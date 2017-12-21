//
//  AZUserLandingScreenViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 24/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController



class AZUserLandingScreenViewController: UIViewController {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var enrolledAmount: UILabel!
    @IBOutlet weak var overdue: UILabel!
    @IBOutlet weak var memberId: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var uerDetailViewModel: AZUserDetailViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = "User information"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
        self.uerDetailViewModel = AZUserDetailViewModel(viewController: self as ViewController)
        self.uerDetailViewModel?.fetchUserInfo()
        self.uerDetailViewModel?.fetchUserPaymentHistory()
        
        let paymentHistoryCellNib = UINib(nibName: "AZPaymentHistoryCell", bundle: nil)
        self.collectionView.register(
            paymentHistoryCellNib, forCellWithReuseIdentifier: "AZPaymentHistoryCell")

    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    
    @IBAction func donateButtonAction(_ sender: UIButton) {
        
        UIApplication.shared.openURL(URL(string: "https://al-zahra-charlotte-donation.cfapps.io/onetimepayment")!)
        
//        let webViewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .webViewController) as? AZWebViewController
//        
//        webViewController?.navTitle = "Donate"
//        webViewController?.deepLinkUrl = "https://al-zahra-charlotte-donation.cfapps.io/onetimepayment"
//        self.navigationController?.pushViewController(webViewController!, animated: true)
    }
}

extension AZUserLandingScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let paymentHistory = self.uerDetailViewModel?.paymentHistoryArray {
            return paymentHistory.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: "AZPaymentHistoryCell",
            for: indexPath) as? AZPaymentHistoryCell)!
        if let paymentHistory = self.uerDetailViewModel?.paymentHistoryArray, paymentHistory.count > 0 {
            cell.configure(paymentDate: paymentHistory[indexPath.row].date!, paymentAmount: paymentHistory[indexPath.row].amount!)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AZUserLandingScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width  , height: 30)
    }
}


extension AZUserLandingScreenViewController: ViewController {
    
    func updateView() {
        print("updateView")
        
        if let paymentHistory = uerDetailViewModel?.paymentHistoryArray, paymentHistory.count > 0 {
            self.collectionView.reloadData()
        }
        
        if let info = self.uerDetailViewModel?.userResponse {
            self.title = info.fullName
            self.fullName.text = info.fullName
            self.phoneNumber.text = String(describing: info.phoneNumber!)
            self.email.text = info.email
            self.enrolledAmount.text = String(describing: info.enrolledAmount!)
            if info.overdue! == 0 || info.overdue! < 0{
                self.overdue.text = "You have no dues"
            } else {
                self.overdue.text = "You have past dues"
            }
            
//            self.overdue.text = String(describing: info.overdue!)
            self.memberId.text = String(describing: info.memberId!)
            self.address.text = info.address
        }
    }
}
