//
//  BackgroundCollectionViewCell.swift
//  The Message App
//
//  Created by Vibol's Macbook Pro on 1/15/19.
//  Copyright © 2019 Vibol Roeun. All rights reserved.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(image: UIImage) {
        self.imageView.image = image
    }
    
}
