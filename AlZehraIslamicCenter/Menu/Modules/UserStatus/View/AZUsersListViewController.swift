//
//  AZUsersListViewController.swift
//  PRGValidationField-Example
//
//  Created by Shabi on 15/11/17.
//  Copyright © 2017 Programize. All rights reserved.
//

import UIKit
import KYDrawerController
import MessageUI

class AZUsersListViewController: UIViewController {
    
    @IBOutlet weak var userListCollectionView: UICollectionView!
    @IBOutlet weak var searchBarView: UISearchBar!
    var allUsers : [AZAllUserResponse]?
    var allUserViewModel: AZAllUserViewModel?
    var allUserList: [AZAllUserResponse]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allUserViewModel = AZAllUserViewModel(viewController: self)
        self.allUserViewModel?.fetchEventInfo()
        setupUI()
        
    }
    func setupUI() {
        
        title = "All Momeneen"
        self.searchBarView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Drawer"), style: .plain, target: self, action: #selector(didTapOpenButton))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        let contactCellNib = UINib(nibName: "AZUserInfoCell", bundle: nil)
        self.userListCollectionView.register(
            contactCellNib, forCellWithReuseIdentifier: "AZUserInfoCell")
    }
    
    func didTapOpenButton(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
}
extension AZUsersListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allUser = self.allUserList {
            return allUser.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(
            withReuseIdentifier: "AZUserInfoCell",
            for: indexPath) as? AZUserInfoCell)!
        if let user = self.allUserList, user.count > 0 {
            cell.configure(userDetail: user[indexPath.row])
            cell.delegate = self
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AZUsersListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width  , height: 316)
    }
}

extension AZUsersListViewController: ViewController {
    
    func updateView() {
        if let user = self.allUserViewModel?.allUserResponse, user.count > 0 {
            self.allUserList = user
        }
        self.userListCollectionView.reloadData()
    }
}

extension AZUsersListViewController: AZUserInfoCellDelegate {
    
    func payOfflineAction(userDetail: AZAllUserResponse) {
        let viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .offlinePaymentViewController) as? AZOfflinePaymentViewController
        viewController?.selectedUser = userDetail
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    func sendEmailAction(userDetail: AZAllUserResponse) {
        let mailComposerVC = self.configureMailController(emailID: userDetail.email!)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            self.showEmailError()
        }
    }
    
    func configureMailController(emailID: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([emailID])
        mailComposerVC.setSubject("From Al Zahra")
        mailComposerVC.setMessageBody("Welcome email from Al Zahra", isHTML: false)
        return mailComposerVC
    }
    
    func showEmailError() {
        AZUtility.showAlert(title: "Could not send email", message: "Your device could not send email", actionTitles: "OK", actions: nil)
    }
    
}

extension AZUsersListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBarView.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.resetCollectionViewData(searchText:"")
        self.searchBarView.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarView.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // to limit network activity, reload half a second after last key press.
        
        if (searchBar.text?.count)! > 0 {
            self.resetCollectionViewData(searchText: searchBar.text ?? "")
        } else {
            if let user = self.allUserViewModel?.allUserResponse, user.count > 0 {
                self.allUserList = user
            }
            self.userListCollectionView.reloadData()
        }
    }
    
    func updateSearchDatabase(searchText: String) {
        if searchText == "" {
            if let allUser = self.allUserViewModel?.allUserResponse {
                self.allUserList = allUser
            }
        } else {
            
            if let allUser = self.allUserViewModel?.allUserResponse {
                
                self.allUserList = allUser.filter( { (user: AZAllUserResponse) -> Bool in
                    
                    if (user.fullName?.lowercased() as AnyObject).contains(searchText.lowercased()) ||
                        (user.phoneNumber?.lowercased() as AnyObject).contains(searchText.lowercased()) ||
                        (user.email?.lowercased() as AnyObject).contains(searchText.lowercased()) {
                        return true
                        
                    } else {
                        return false
                    }
                })
            }
            
        }
    }
    
    
    func resetCollectionViewData(searchText: String) {
        
        self.updateSearchDatabase(searchText: searchText)
        self.userListCollectionView.reloadData()
    }
    
    func resignSearchBarKeyboard() {
        self.searchBarView.resignFirstResponder()
    }
}

extension AZUsersListViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue :
            print("Cancelled")
            
        case MFMailComposeResult.failed.rawValue :
            AZUtility.showAlert(title: "Email", message: "Failed to send email", actionTitles: "OK", actions: nil)
            print("Failed")
            
        case MFMailComposeResult.saved.rawValue :
            AZUtility.showAlert(title: "Email", message: "Email is saved", actionTitles: "OK", actions: nil)
            print("Saved")
            
        case MFMailComposeResult.sent.rawValue :
            AZUtility.showAlert(title: "Email", message: "Your email is sent successfully", actionTitles: "OK", actions: nil)
            print("Sent")
            
            
            
        default: break
            
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
