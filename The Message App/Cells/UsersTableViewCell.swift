//
//  UsersTableViewCell.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/2/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func generateCellWith(fUser: FUser, indexPath: IndexPath) {
        
        self.indexPath = indexPath
        
        self.fullNameLabel.text = fUser.fullname
        
        if fUser.avatar != "" {
            imageFromData(pictureData: fUser.avatar) { (avatarImage) in
                if avatarImageView != nil {
                    self.avatarImageView.image = avatarImage?.circleMasked
                }
            }
        }
    }

}
