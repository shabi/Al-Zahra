//
//  AZUserInfoCell.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 15/11/17.
//  Copyright © 2017 Programize. All rights reserved.
//

import UIKit

protocol AZUserInfoCellDelegate: class {
    func payOfflineAction(userDetail: AZAllUserResponse)
    func sendEmailAction(userDetail: AZAllUserResponse)
}

class AZUserInfoCell: UICollectionViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var memberID: UILabel!
    @IBOutlet weak var enrolledAmount: UILabel!
    @IBOutlet weak var overdue: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var emailButton: UIButton!
    
    var userInfo: AZAllUserResponse?
    weak var delegate: AZUserInfoCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.borderWidth = 1.0
        self.bgView.layer.borderColor = UIColor.clear.cgColor
        self.bgView.layer.shadowColor = UIColor(red: 52, green: 76, blue: 74).cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.bgView.layer.shadowRadius = 2.0
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.masksToBounds = false
    }
    
    func configure(userDetail: AZAllUserResponse) {
        self.name.text = userDetail.fullName ?? ""
//        self.email.text = userDetail.email ?? ""
        self.phoneNum.text = userDetail.phoneNumber
        self.memberID.text = String(describing: userDetail.memberId ?? 0)
        self.enrolledAmount.text = String(describing: userDetail.enrolledAmount ?? 0)
        self.overdue.text = String(describing: userDetail.overdue ?? 0)
        self.emailButton.setTitle(userDetail.email ?? "", for: .normal)
//        self.address.text = userDetail.address ?? ""
        self.userInfo = userDetail
    }
    
    @IBAction func sendEmailClicked(_ sender: Any) {
        self.delegate?.sendEmailAction(userDetail: self.userInfo!)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.delegate?.payOfflineAction(userDetail: self.userInfo!)
    }
}
