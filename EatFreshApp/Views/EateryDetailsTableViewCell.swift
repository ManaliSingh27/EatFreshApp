//
//  EateryDetailsTableViewCell.swift
//  EatFreshApp
//
//  Created by Manali Mogre on 17/03/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import UIKit

class EateryDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var openHrsLabel: UILabel!
    @IBOutlet weak var vicinityLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class EateryImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var eateryImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class EateryUserReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var authorProfilePicImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
