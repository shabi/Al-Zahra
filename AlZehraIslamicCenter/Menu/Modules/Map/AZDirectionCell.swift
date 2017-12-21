//
//  AZDirectionCell.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 23/11/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit

class AZDirectionCell: UICollectionViewCell {

    @IBOutlet weak var directionDetail: UILabel!
    @IBOutlet weak var directionDescription: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        widthConstraint.constant = screenWidth - (2 * 12)
        // Initialization code
//        self.bgView.layer.borderWidth = 1.0
//        self.bgView.layer.borderColor = UIColor.clear.cgColor
//        self.bgView.layer.shadowColor = UIColor.white.cgColor
//        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.bgView.layer.shadowRadius = 2.0
//        self.bgView.layer.shadowOpacity = 0.25
//        self.bgView.layer.masksToBounds = false
    }
    
    func configure(eventDetails: AZUpComingEventModel) {
        
    }
}
