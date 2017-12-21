//
//  AZEventCollectionViewCell.swift
//  AlZehraIslamicCenter
//
//  Created by Shabi on 30/10/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit

protocol AZEventCollectionViewCellDelegate: class {
    func deleteEventForId(eventId: Int?)
}

class AZEventCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventDateImageView: UIImageView!
    
    @IBOutlet weak var deleteEventButton: UIButton!
    @IBOutlet weak var eventKindImageView: UIImageView!
    @IBOutlet weak var eventTimeImageeView: UIImageView!
    @IBOutlet weak var eventGuestImageView: UIImageView!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    @IBOutlet weak var eventStartTime: UILabel!
    @IBOutlet weak var eventEndTime: UILabel!
    @IBOutlet weak var eventKind: UILabel!
    @IBOutlet weak var eventGuest: UILabel!
    @IBOutlet weak var bgView: UIView!
    weak var delegate: AZEventCollectionViewCellDelegate?
    var eventId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        super.awakeFromNib()
        // Initialization code
        self.bgView.layer.borderWidth = 1.0
        self.bgView.layer.borderColor = UIColor.clear.cgColor
        self.bgView.layer.shadowColor = UIColor.black.cgColor //UIColor(red: 52, green: 76, blue: 74).cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        self.bgView.layer.shadowRadius = 2.0
        self.bgView.layer.shadowOpacity = 0.5
        self.bgView.layer.masksToBounds = false
    }
    
    @IBAction func deleteEvent(_ sender: Any) {
        self.delegate?.deleteEventForId(eventId: self.eventId)
    }
    
    func configure(eventDetails: AZUpComingEventModel) {
        
        self.eventStartDate.text = eventDetails.fromDate?.getDateWithFormat(format: .dateTimeTFormat)?.getStringWithFormat(format: .dateFormat)
        self.eventEndDate.text = eventDetails.toDate?.getDateWithFormat(format: .dateTimeTFormat)?.getStringWithFormat(format: .dateFormat)
        self.eventStartTime.text = eventDetails.fromDate?.getDateWithFormat(format: .dateTimeTFormat)?.getStringWithFormat(format: .timeFormat)
        self.eventEndTime.text = eventDetails.toDate?.getDateWithFormat(format: .dateTimeTFormat)?.getStringWithFormat(format: .timeFormat)
        self.eventKind.text = eventDetails.eventName
        self.eventGuest.text = eventDetails.speakerName
        self.eventId = eventDetails.eventId
        
        if Keychain.loadValueFromKeychain(key: Constants.KeyChain.role)! == "SuperAdmin" || Keychain.loadValueFromKeychain(key: Constants.KeyChain.role)! == "Admin" {
            self.deleteEventButton.isHidden = false
        } else {
            self.deleteEventButton.isHidden = true
        }
    }
}

