//
//  EateryTableViewCell.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 16/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class EateryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var eateryNameLabel: UILabel!
    
    @IBOutlet weak var openLabel: UILabel!
    
    @IBOutlet weak var ratingsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
