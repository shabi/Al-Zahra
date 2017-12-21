//
//  Storyboard+Extension.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 23/09/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

    public enum Storyboard: String {
        case main
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    public enum StoryboardIdentifier: String {
        
        case drawerViewController = "AZDrawerViewController"
        case kyDrawerController = "KYDrawerController"
        case landingViewController = "AZLandingViewController"
        case eventViewController = "AZEventViewController"
        case announcementViewController = "AZAnnouncementViewController"
        case islamicSchoolViewController = "AZIslamicSchoolViewController"
        case funeralServiceViewController = "AZFuneralServiceViewController"
        case marriageServiceViewController = "AZMarriageServiceViewController"
        case directionViewController = "AZDirectionViewController"
        case supportViewController = "AZSupportViewController"
        case missionViewController = "AZMissionViewController"
        case contactUsViewController = "AZContactUsViewController"
        case signOutViewController = "AZSignOutViewController"
        case createEventViewController = "AZCreateEventViewController"
        case usersListViewController = "AZUsersListViewController"
        case directionMapViewController = "AZDirectionMapViewController"
        case directionDetailViewController = "AZDirectionDetailViewController"
        case userLandingScreenViewController = "AZUserLandingScreenViewController"
        case offlinePaymentViewController = "AZOfflinePaymentViewController"
        case webViewController = "AZWebViewController"
        case loginViewController = "AZLoginViewController"
        case wkViewController = "AZWKViewController"
        case qiblaFinder = "AZQiblaFinder"
        
        
    }
    
    public enum Segues: String {
        case landingViewController = "main"
        case drawerViewController = "drawer"
    }
    
    class func getViewController(storyboard: Storyboard,  bundle: Bundle? = nil,
                                 identifier: StoryboardIdentifier) ->UIViewController {
        print(storyboard.filename)
        let _storyboard = UIStoryboard(name: storyboard.filename, bundle: bundle)
        return _storyboard.instantiateViewController(withIdentifier: identifier.rawValue)
    }
}
