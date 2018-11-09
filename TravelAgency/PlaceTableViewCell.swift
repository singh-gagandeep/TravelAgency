//
//  PlaceTableViewCell.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-14.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

// PlaceTableViewCell represent each subview(entry) in tableview

class PlaceTableViewCell: UITableViewCell {
    //MARK: properties
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placePhotoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
