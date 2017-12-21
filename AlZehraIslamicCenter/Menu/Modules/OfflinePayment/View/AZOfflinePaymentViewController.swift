//
//  AZOfflinePaymentViewController.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 19/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import KYDrawerController

class AZOfflinePaymentViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var amountEnrolled: UILabel!
    @IBOutlet weak var overdue: UILabel!
    @IBOutlet weak var offlineAmounttextField: UITextField!
    
    var selectedUser: AZAllUserResponse?
    var offlinePaymentViewModel: AZOfflinePaymentViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Offline Payment"
        
        self.name.text = selectedUser?.fullName
        self.email.text = selectedUser?.email
        if let enrolledAmount = selectedUser?.enrolledAmount {
            self.amountEnrolled.text = String(describing: enrolledAmount)
        }
        if let overdue = selectedUser?.overdue {
            self.overdue.text = String(describing: overdue)
        }
        
        self.offlinePaymentViewModel = AZOfflinePaymentViewModel(viewController: self)
        
    }

    
    @IBAction func payOfflineButtonTapped(_ sender: UIButton) {
        print("It works, boo!")
        
        let currentDate = AZUtility.getCurrentDayMonthYear()
        let currentDateStr = "\(currentDate.month)-\(currentDate.day)-\(currentDate.year)"
        let userDetail = ["userId": self.selectedUser?.userId  as AnyObject,
                               "transDate": currentDateStr  as AnyObject,
                               "amount": Int(self.offlineAmounttextField.text!)  as AnyObject,
                               "comments": "Offline payment done."  as AnyObject,
                               "dbCr": "C"  as AnyObject,
                               "deleted": false  as AnyObject,
                               "createdBy": Keychain.loadValueFromKeychain(key: Constants.KeyChain.userId)!  as AnyObject]
        
        self.offlinePaymentViewModel?.offlineResponse = AZOfflineResponse(dictionary: userDetail as NSDictionary)
        self.offlinePaymentViewModel?.payOffline()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension AZOfflinePaymentViewController: ViewController {
    
    func updateView() {
        AZUtility.showAlert(title: "Offline Payment", message: "Successfully payment done.", actionTitles: "OK", actions: nil)
        self.offlineAmounttextField.text = ""
    }
}

extension AZOfflinePaymentViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
