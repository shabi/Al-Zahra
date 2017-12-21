//
//  AZPaymentHistoryCell.swift
//  AlZehraIslamicCenter
//
//  Created by azicc-shabi.naqvi on 15/12/17.
//  Copyright © 2017 Shabi. All rights reserved.
//

import UIKit
import Foundation

class AZPaymentHistoryCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
    
    func configure(paymentDate: String, paymentAmount: Int) {
        dateLabel.text = convertDateFormater(paymentDate)
        amountLabel.text = String(paymentAmount)
    }
}
