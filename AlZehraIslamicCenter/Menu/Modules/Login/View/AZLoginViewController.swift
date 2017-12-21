//
//  AZLoginViewController.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 24/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import KYDrawerController

class AZLoginViewController: UIViewController, GIDSignInUIDelegate {
    
//    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var userName: PRGValidationField!
    
    @IBOutlet weak var password: PRGValidationField!
    
    var loginViewModel: AZLoginViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GIDSignIn.sharedInstance().uiDelegate = self
    }
    @IBAction func loginAction(_ sender: Any) {
        if self.userName.text?.count == 0 , self.password.text?.count == 0 {
            AZUtility.showAlert(title: "Login", message: "User name or Password is not valid.", actionTitles: "OK", actions: nil)
            return
        }
        
        let reqDic = ["username": self.userName.text, "password": self.password.text, "grant_type": "password"]
        self.loginViewModel = AZLoginViewModel(viewController: self, requestDic: reqDic as! [String : String])
        self.loginViewModel?.fetchUserInfo()
    }

    @IBAction func handleButtonClicked() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func gotToSignUpPage(sender: AnyObject) {
        
        
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let signUpViewNavController = mainStory.instantiateViewController(withIdentifier: "AZSignUpViewNavController")
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(0.5)
        self.present(signUpViewNavController, animated: true, completion: nil)
        UIView.commitAnimations()
        
    }
}

extension AZLoginViewController: ViewController {
    
    func updateView() {
        print("updateView")
        if self.loginViewModel?.errResponse == nil {
        
            let landingViewController   = UIStoryboard.getViewController(storyboard: .main, identifier: .userLandingScreenViewController) as? AZUserLandingScreenViewController
            
            let drawerViewController = UIStoryboard.getViewController(storyboard: .main, identifier: .drawerViewController) as? AZDrawerViewController
            let userInfo = AZUserInfoModel(userName: self.loginViewModel?.loginResponse?.userName, userEmail: self.loginViewModel?.loginResponse?.userName, userImageURL: nil)
            drawerViewController?.userInfo = userInfo
            
            let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: (UIScreen.main.bounds.size.width)*0.8)
            drawerController.mainViewController = UINavigationController(
                rootViewController: landingViewController!
            )
            
            drawerController.drawerViewController = drawerViewController
            
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = drawerController
            appDelegate?.window??.makeKeyAndVisible()
        }
    }
}
