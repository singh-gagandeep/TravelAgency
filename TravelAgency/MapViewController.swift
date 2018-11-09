
//
//  MapViewController.swift
//  TravelAgency
//
//  Created by Gagan on 2017-12-15.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import UIKit
import MapKit

// class show mapview based on the address provided by PlaceViewController.

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! // reference to mapview
    var geoCoder = CLGeocoder() // class to handle geocoding/reversegeocoding of addresses.
    var address: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showMap() // show map when view already loaded.
    }
    
    func showMap() {
        geoCoder.geocodeAddressString(address, completionHandler: {placeMarks, error in
            // optional chaining
            // check for error
            if error != nil {
                print("\(error)")
                return
            }
            // optional binding
            if let placeMarksCount = placeMarks?.count, placeMarksCount > 0, let placeMark = placeMarks?[0] {
                let location = placeMark.location
                let coordinate = location?.coordinate
                self.mapView.setCenter(CLLocationCoordinate2D(latitude:
                    (coordinate?.latitude)!, longitude: (coordinate?.longitude)!), animated: true)
                
                
                // defining visible area of the map
                let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
                //setting region to display
                let mapRegion = MKCoordinateRegion(center: (location?.coordinate)!, span: mapSpan)
                
                // show annotation on map with drop pin
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = (location?.coordinate)!
                dropPin.title = self.address
                self.mapView.addAnnotation(dropPin)
                self.mapView.setRegion(mapRegion, animated: true)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
