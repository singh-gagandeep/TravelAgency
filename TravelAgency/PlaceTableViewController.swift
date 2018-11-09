//
//  PlaceTableViewController.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-14.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import os.log

// table view controller display all the places with their ratings images and name

class PlaceTableViewController: UITableViewController {
    
    // MARK: properties
    var places = [Place]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem // add edit button on the top left of navigational bar
        loadSamplePlaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return number of rows in table view
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlaceTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaceTableViewCell else {
            fatalError("The dequeued cell is not an instance of PlaceTableViewCell.")
        }
        // each cell represent entry in table
        // each entry has sub views
        let place = places[indexPath.row]
        cell.placeNameLabel.text = place.name
        cell.placePhotoImageView.image = place.photo
        cell.ratingControl.rating = place.rating

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    // MARK: private methods
    // default entries
    private func loadSamplePlaces() {
        let photo1 = UIImage(named: "niagara falls")
        guard let place1 = Place(name: "Niagara Falls", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate place1")
        }
        places.append(place1)
    }
    
    // multiple segue from a single view controller differentiated by their
    // identifiers assigned in Interface Builder
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            // handles when add button pressed on top right corner
            case "AddPlace":
                os_log("Adding a new place.", log: OSLog.default, type: .debug)
            
            // handle when user press item in table view controller and display information of the place
            case "showPlaceBriefInfo":
                // try casting destination view controller to PlaceBriefInfoViewController
                guard let placeShowBriefViewController = segue.destination as? PlaceBriefInfoViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                // get cell which was selected by user
                guard let selectedPlaceCell = sender as? PlaceTableViewCell else {
                    fatalError("Unexpected sender: \(sender)")
                }
                
                // index of the cell user tapped
                guard let indexPath = tableView.indexPath(for: selectedPlaceCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                // place associated with that index
                let selectedPlace = places[indexPath.row]
                // update place property of the destination viewcontroller i.e PlaceShowBriefViewController
                placeShowBriefViewController.place = selectedPlace
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier)")
            }
    }
    // unwind segues are used to pass information back to source viewcontroller
    // after forward segues are processed by destination viewcontroller
    // called when user press save button in PlaceShowBriefViewController.
    @IBAction func unwindToPlaceTableViewController
        (sender: UIStoryboardSegue) {
        // check if it was coming from viewcontroller which is expected
        if let sourceViewController = sender.source as? PlaceViewController, let place = sourceViewController.place {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                print("Updating existing")
                // Update an existing place.
                places[selectedIndexPath.row] = place
                places[selectedIndexPath.row].rating = place.rating
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new place.
                print("Adding New")
                let newIndexPath = IndexPath(row: places.count, section: 0)
                // update array of places
                places.append(place)
                // update table row with new place object
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }

        }
        // make table reload its entries
        tableView.reloadData()
    }
    
}
