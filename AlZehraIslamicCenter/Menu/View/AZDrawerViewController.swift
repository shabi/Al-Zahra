//
//  AZDrawerViewController.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 23/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import GoogleSignIn

enum DrawerConstant {
    static let menuItemHeight: CGFloat = 50.0
}

enum UserType: String {
    case admin
    case user
}

class AZDrawerViewController: UIViewController {

    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var drawerCollectionView: UICollectionView!
    var menuItemsArray = [String]()
    var menuIconArray = [String]()
    
    var userType: UserType = .user {
        didSet {
            
            switch userType {
            case .user:
                self.menuItemsArray = ["Account Detail", "Prayer Times", "Events", "Al-Zahra Islamic School", "Funeral Services", "Marriage Services", "Our Mission", "Contact Us", "Sign Out"]
                self.menuIconArray = ["AccountInfo", "Time", "Event", "School", "Funeral", "Marriage", "Mission", "Contact", "SignOut"]
                
            case .admin:
                self.menuItemsArray = ["Account Detail", "Prayer Times", "Events", "Create Event", "All Users", "Al-Zahra Islamic School", "Funeral Services", "Marriage Services", "Our Mission", "Contact Us", "Sign Out"]
                self.menuIconArray = ["AccountInfo", "Time",  "Event" , "NewEvent", "AllUser", "School", "Funeral", "Marriage", "Mission", "Contact", "SignOut"]
            }
        }
        
    }
    
    var userInfo:AZUserInfoModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        if Keychain.loadValueFromKeychain(key: Constants.KeyChain.role) == "SuperAdmin" {
            self.userType = .admin
        } else {
            self.userType = .user
        }

        self.setupUI()
    }
    
    func setupUI() {
        let menuItemCollectionViewNib =  UINib(nibName: AZMenuItemCollectionViewCell.className, bundle: nil)
        self.drawerCollectionView.register(menuItemCollectionViewNib, forCellWithReuseIdentifier: AZMenuItemCollectionViewCell.className)
        
        userImageView.layer.borderWidth = 1
        userImageView.layer.masksToBounds = false
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        userEmail.text = self.userInfo?.userEmail
        userName.text = self.userInfo?.userName
        
        if let checkedUrl = URL(string: (self.userInfo?.userImageURL?.absoluteString) ?? "") {
            self.userImageView.contentMode = .scaleAspectFit
            downloadImage(url: checkedUrl)
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                self.userImageView.image = UIImage(data: data)
            }
        }
    }
    
    func didTapClose() {
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.closed, animated: true)
        }
    }

}

extension AZDrawerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AZMenuItemCollectionViewCell.className, for: indexPath) as? AZMenuItemCollectionViewCell
        
        cell?.menuLabel.text = self.menuItemsArray[indexPath.row]
        cell?.menuIconImageView.image = UIImage(named: self.menuIconArray[indexPath.row])
        return cell!
    }
}

extension AZDrawerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let navigationController = (self.parent as? KYDrawerController)?.mainViewController as? UINavigationController
        navigationController?.viewControllers.removeAll()
        var viewController: UIViewController?
    
        if Keychain.loadValueFromKeychain(key: Constants.KeyChain.role) == "SuperAdmin" {
            if indexPath.row == 0 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .userLandingScreenViewController) as? AZUserLandingScreenViewController //"Account Detail"
            } else if indexPath.row == 1 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .landingViewController) as?
                AZLandingViewController //"Prayer Times"
            } else if indexPath.row == 2 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .eventViewController) as?
                AZEventViewController //"Events"
            } else if indexPath.row == 3 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .createEventViewController) as? AZCreateEventViewController //"Create Event"
            } else if indexPath.row == 4 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .usersListViewController) as? AZUsersListViewController //"All Users"
            } else if indexPath.row == 5 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .islamicSchoolViewController) as? AZIslamicSchoolViewController
                
            } else if indexPath.row == 6 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .funeralServiceViewController) as? AZFuneralServiceViewController
                
            } else if indexPath.row == 7 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .marriageServiceViewController) as? AZMarriageServiceViewController
                
            } else if indexPath.row == 8 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .missionViewController) as? AZMissionViewController
                
            } else if indexPath.row == 9 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .contactUsViewController) as? AZContactUsViewController
                
            } else if indexPath.row == 10 {
                AZAuthTokenResponse.resetKeychainItems()
                let loginViewController   = UIStoryboard.getViewController(storyboard: .main, identifier: .loginViewController) as? AZLoginViewController
                
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = loginViewController
                appDelegate?.window??.makeKeyAndVisible()
            }
        } else {
            
            if indexPath.row == 0 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .userLandingScreenViewController) as? AZUserLandingScreenViewController //"Account Detail"
            } else if indexPath.row == 1 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .landingViewController) as?
                AZLandingViewController //"Prayer Times"
            } else if indexPath.row == 2 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .eventViewController) as?
                AZEventViewController //"Events"
            } else if indexPath.row == 3 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .islamicSchoolViewController) as? AZIslamicSchoolViewController
                
            } else if indexPath.row == 4 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .funeralServiceViewController) as? AZFuneralServiceViewController
                
            } else if indexPath.row == 5 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .marriageServiceViewController) as? AZMarriageServiceViewController
                
            } else if indexPath.row == 6 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .missionViewController) as? AZMissionViewController
                
            } else if indexPath.row == 7 {
                viewController  = UIStoryboard.getViewController(storyboard: .main, identifier: .contactUsViewController) as? AZContactUsViewController
                
            } else if indexPath.row == 8 {
                AZAuthTokenResponse.resetKeychainItems()
                let loginViewController   = UIStoryboard.getViewController(storyboard: .main, identifier: .loginViewController) as? AZLoginViewController
                
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = loginViewController
                appDelegate?.window??.makeKeyAndVisible()
            }
        }
        if let viewController = viewController {
            navigationController?.setViewControllers([viewController], animated: true)
        } else {
            navigationController?.viewControllers.removeAll()
        }

        navigationController?.popViewController(animated: true)

        self.didTapClose()
    }
}

extension AZDrawerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.drawerCollectionView.frame.size.width, height: DrawerConstant.menuItemHeight)
    }
    
}
