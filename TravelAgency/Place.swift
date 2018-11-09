//
//  Place.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-14.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit

// class represent place
class Place {
    // MARK: properties
    var name: String // name of the place
    var photo: UIImage? // image of the place
    var rating: Int // user rating of the image
    
    // failsafe initializer that can return nil
    init?(name: String, photo: UIImage?, rating: Int) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}
