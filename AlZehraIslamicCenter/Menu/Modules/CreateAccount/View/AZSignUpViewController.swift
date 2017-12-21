//
//  AZSignUpViewController.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 15/11/17.
//  Copyright © 2017 Programize. All rights reserved.
//

import UIKit

enum AmountType: String {
    case fifty = "50"
    case sixty = "60"
}

enum StateType: Int {
    case nc
    case sc
}


class AZSignUpViewController: UIViewController, PRGValidationFieldDelegate {
    
    @IBOutlet weak var nameField: PRGValidationField!
    @IBOutlet weak var surnameField: PRGValidationField!
    @IBOutlet weak var emailField: PRGValidationField!
    @IBOutlet weak var passwordField: PRGValidationField!
    @IBOutlet weak var confirmPasswordField: PRGValidationField!
    @IBOutlet weak var phoneNumber: PRGValidationField!
    @IBOutlet weak var streetName: PRGValidationField!
    @IBOutlet weak var zipCode: PRGValidationField!
    @IBOutlet weak var cityName: PRGValidationField!
    var stateName: String?
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var fiftyRupeesButton: UIButton!
    @IBOutlet weak var sixtyRuppesButton: UIButton!
    
    @IBOutlet weak var ncState: UIButton!
    @IBOutlet weak var scState: UIButton!
    
    
    var createAccountViewModel: AZCreateAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        passwordField.otherPasswordField = confirmPasswordField
        
        nameField.delegate = self
        surnameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        phoneNumber.delegate = self
        streetName.delegate = self
        zipCode.delegate = self
        cityName.delegate = self
        self.createAccountViewModel = AZCreateAccountViewModel(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var stateType: StateType = .nc {
        didSet {
            switch stateType {
            case .nc:
                self.defaultStateSelected()
                self.ncState.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            case .sc:
                self.defaultStateSelected()
                self.scState.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            }
        }
    }
    
    var amountSelected: AmountType = .fifty {
        didSet {
            switch amountSelected {
            case .fifty:
                self.defaultAmountSetting()
                self.fiftyRupeesButton.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            case .sixty:
                self.defaultAmountSetting()
                self.sixtyRuppesButton.setImage(UIImage(named: "SelectedRadio"), for: .normal)
            }
        }
    }
    
    
    func defaultAmountSetting()  {
        self.fiftyRupeesButton.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
        self.sixtyRuppesButton.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
    }
    
    func defaultStateSelected()  {
        self.ncState.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
        self.scState.setImage(UIImage(named: "unSelectedRadio"), for: .normal)
    }
    
    func PRGValidationField(_field: PRGValidationField, didValidateWithResult result: Bool, andErrorMessage errorMessage: String?) {
        if !result {
            _field.errorLabel.text = errorMessage
            _field.errorLabel.isHidden = false
        } else {
            _field.errorLabel.isHidden = true
        }
        
        registerButton.isEnabled = nameField.isValid ?? false && surnameField.isValid ?? false && emailField.isValid ?? false && passwordField.isValid ?? false && confirmPasswordField.isValid ?? false
    
    }
    
    @IBAction func dissmissButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        print("It works, boo!")
    }
    
    @IBAction func stateSelected(_ sender: UIButton) {
        
        if sender.tag == 0 {
            self.stateName = "NC"
            self.stateType = .nc
        } else if sender.tag == 1 {
            self.stateName = "SC"
            self.stateType = .sc
            
        }
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        print("It works, boo!")
        self.resignFirstResponder()
        
        let signUpDic = ["email": self.emailField.text as AnyObject, "userName": self.emailField.text as AnyObject,
                        "firstName": self.nameField.text as AnyObject, "lastName": self.surnameField.text as AnyObject,
                        "password": self.passwordField.text as AnyObject, "confirmPassword": self.confirmPasswordField.text as AnyObject,
                        "phoneNumber": self.phoneNumber.text as AnyObject, "roleName": "User" as AnyObject,
                        "address": self.streetName.text as AnyObject, "city": self.cityName.text as AnyObject,
                        "stateCode": self.stateName as AnyObject, "zipCode": self.zipCode.text as AnyObject,
                        "amount": self.amountSelected.rawValue as AnyObject]
 
        
        self.createAccountViewModel?.createAccountRequest = AZCreateAccountRequest(dictionary: signUpDic as NSDictionary)
        self.createAccountViewModel?.craeteUser()
    }
    
    @IBAction func amountSelectedAction(_ sender: Any) {
        
        if (sender as? UIButton)?.tag == 1 {
            self.amountSelected = .sixty
        } else {
            self.amountSelected = .fifty
        }
        
    }
}

extension AZSignUpViewController: ViewController {
    
    func updateView() {
        AZUtility.showAlert(title: "Create New Account", message: "Auto generated email is sent to your email address, please verify the same.", actionTitles: "OK", actions: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
