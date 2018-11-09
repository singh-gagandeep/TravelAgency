//
//  RatingControl.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-12.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

// This control implements the visual feedback that user can express visually (number of stars)

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    // computational properties are preperties that we can define
    //operation that can be performed before or after assigning properties
    var rating = 0 {
        didSet { // called after property is set
            updateButtonSelectionStates()
        }
    }
    // array for 5 rating buttons
    private var ratingButtons = [UIButton]()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // function that add button on rating control and set callback for each button
    // with the help of selectors
    
    private func setupButtons() {
        // remove buttons from stackview initially
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // define images for button appearance
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // set image and callback for each button
        for _ in 0..<5 {
            let button = UIButton()
            button.setImage(emptyStar, for: .normal) // for unselected star
            button.setImage(filledStar, for: .selected) // for selected
            button.setImage(highlightedStar, for: .highlighted) // while highlighted
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        
            addArrangedSubview(button)
            ratingButtons.append(button)
        }
    }
    // callback when user press button on rating control
    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
}
