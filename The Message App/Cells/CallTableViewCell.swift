//
//  CallTableViewCell.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 2/6/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit

class CallTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func generateCellWith(call: CallClass) {
        
        dateLabel.text = formatCallTime(date: call.callDate)
        statusLabel.text = ""
        
        if call.callerId == FUser.currentId() {
            
            statusLabel.text = "Outgoing"
            fullNameLabel.text = call.withUserFullName
//            avatarImageView.image = UIImage(named: "Outgoing")
            
        } else {
            statusLabel.text = "Incoming"
            fullNameLabel.text = call.callerFullName
//            avatarImageView.image = UIImage(named: "Incoming")
        }
        
    }


}
