//
//  PlaceViewController.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-12.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import os.log // For debugging/ logging
import CoreData // persistant data

class PlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    //MARK: properties
    @IBOutlet weak var personNameTextField: UITextField! // person Name
    @IBOutlet weak var personPlaceOfBirthTextField: UITextField! // place of birth
    @IBOutlet weak var personDateOfBirthDatePicker: UIDatePicker!
    
    @IBOutlet weak var journeySourceTextField: UITextField!
    @IBOutlet weak var journeyDestinationTextField: UITextField!
    
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeDescriptionTextView: UITextView!
    @IBOutlet weak var placePhotoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var place: Place?   // place type with name, rating and photo
    var activeTextField = UITextField() // currently focused text field
    var activeTextView = UITextView() //currently focusted text view
    
    var persons = [Person]()
    var feedbacks = [Feedback]()
    var travelData = [TravelData]()
    
    // called when all view object are drawn on screen.
    // delegate objects act on behalf actual views like text fields etc..
    override func viewDidLoad() {
        super.viewDidLoad()
        personNameTextField.delegate = self
        personPlaceOfBirthTextField.delegate = self
        journeySourceTextField.delegate = self
        journeyDestinationTextField.delegate = self
        placeNameTextField.delegate = self
        placeDescriptionTextView.delegate = self
        // Text View made to look like text field
        // description field view multiline text
        placeDescriptionTextView.layer.borderWidth = 1
        placeDescriptionTextView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        placeDescriptionTextView.layer.cornerRadius = 5
        
        saveButton.isEnabled = false // disable save button intially
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /* update title of navigation bar as enter place name in the text field */
        if textField == placeNameTextField { // title set against placeNameTextField ignore rest
            if textField.text == "" {
                navigationBar.title = "New Place"
            } else {
                navigationBar.title = textField.text
            }
            updateSaveButtonState() // enable save if placeNameTextField not empty
        }
    }
    
    // viewcontroller to select image. called when user tap imageview
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        placePhotoImageView.image = selectedImage // assign image to imageview
        dismiss(animated: true, completion: nil) //dismiss view controller after selection
    }
    
    // cancel imagePicker view controller if user pressed cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = placeNameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        activeTextView.resignFirstResponder()
        activeTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    // do some operation just before the new viewCOntroller transition takeplace
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // if user pressed view map button segue with `showMap' identifier triggered
        if segue.identifier == "showMap" {
            guard let mapViewController = segue.destination as? MapViewController, let address = placeNameTextField.text else {
                return
            }
            if address.isEmpty {
                mapViewController.address = "Canada"
            } else {
                mapViewController.address = address
            }
        }
        // check if save button was pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = placeNameTextField.text ?? ""
        let photo = placePhotoImageView.image
        let rating = ratingControl.rating
        
        // set the place attribute accordingly to pass back to PlaceTableViewController
        place = Place(name: name, photo: photo, rating: rating)
    }
}

