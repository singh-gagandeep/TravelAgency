//
//  placeBriefInfoViewController.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-15.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import os.log

// this class show brief info of the place
class PlaceBriefInfoViewController: UIViewController {
    
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placePhotoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load items in view controller
        if let place = place {
            navigationItem.title = place.name
            placePhotoImageView.image = place.photo
            ratingControl.rating = place.rating
            placeNameTextField.text = place.name
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // user tap cancel button
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddPlaceMode = presentingViewController is UINavigationController
        
        if isPresentingInAddPlaceMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The PlaceViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = placeNameTextField.text ?? ""
        let photo = placePhotoImageView.image
        let rating = ratingControl.rating
        
        // Set the place to be passed back to PlaceTableViewController when user tap save.
         place = Place(name: name, photo: photo, rating: rating)
    }
}
