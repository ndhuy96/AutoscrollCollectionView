//
//  DishesCell.swift
//  AutoscrollCollectionView
//
//  Created by Nguyen Duc Huy B on 6/15/20.
//  Copyright © 2020 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class DishesCell: UICollectionViewCell {
    @IBOutlet weak var dishImageView: UIImageView!
    
    func configCell(_ imageString: String) {
        dishImageView.image = UIImage(named: imageString)
    }
}
