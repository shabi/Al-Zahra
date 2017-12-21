//
//  AppDelegate.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 23/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController
import Firebase
import GoogleSignIn
import FirebaseAuth
import GoogleMaps
import GooglePlaces
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        // Override point for customization after application launch.
        
        

        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        
        application.registerForRemoteNotifications()
        
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GMSServices.provideAPIKey("AIzaSyC3rRfe_RQGozrjBqrj_h_D98UKeLFLnQw")
        GMSPlacesClient.provideAPIKey("AIzaSyC3rRfe_RQGozrjBqrj_h_D98UKeLFLnQw")
        UIApplication.shared.statusBarStyle = .lightContent
        
        if let token = Keychain.loadValueFromKeychain(key: Constants.KeyChain.accessToken), token.count > 0 {
            self.launchLandingScreen()
        }
        
        return true
    
    }
    
    func launchLandingScreen() {
        
        let landingViewController   = UIStoryboard.getViewController(storyboard: .main, identifier: .userLandingScreenViewController) as? AZUserLandingScreenViewController
        
        let drawerViewController = UIStoryboard.getViewController(storyboard: .main, identifier: .drawerViewController) as? AZDrawerViewController
        let userInfo = AZUserInfoModel(userName: Keychain.loadValueFromKeychain(key: Constants.KeyChain.userName), userEmail: Keychain.loadValueFromKeychain(key: Constants.KeyChain.userName), userImageURL: nil)
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:])
    }

}

extension AppDelegate: GIDSignInDelegate{

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("Failed to create google account: \(error.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)

        var userImageURL: URL?
        if user?.profile.hasImage == true {
            userImageURL = user?.profile.imageURL(withDimension: 100)
        }
        let userInfo = AZUserInfoModel(userName: user?.profile.givenName,
                                       userEmail: user?.profile.email, userImageURL: userImageURL, isUserHasImage: (user?.profile.hasImage)!)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                print("Failed to create google account: \(error.localizedDescription)")
                return
            }
            // User is signed in
            // ...

            guard let uid = user?.uid else { return }

            print("Successfully signed In", uid)
            
            let landingViewController   = UIStoryboard.getViewController(storyboard: .main, identifier: .landingViewController) as? AZLandingViewController
    
            let drawerViewController = UIStoryboard.getViewController(storyboard: .main, identifier: .drawerViewController) as? AZDrawerViewController
            drawerViewController?.userInfo = userInfo
    
            let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: (UIScreen.main.bounds.size.width)*0.8)
            drawerController.mainViewController = UINavigationController(
                rootViewController: landingViewController!
            )
    
            drawerController.drawerViewController = drawerViewController
    
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = drawerController
            self.window?.makeKeyAndVisible()
        }

    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        if let error = error {
            // ...
            print("Failed to create google account: \(error.localizedDescription)")
            return
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        let dic = userInfo["aps"] as! NSDictionary
        let messsage = dic["alert"]
        print(messsage as! String)
        
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//    }
//
//    func swizzled_application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//    }
//

}

