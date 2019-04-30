//
//  PlacesMapViewController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/13/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit
import GoogleMaps

class PlacesMapViewController: UIViewController, GMSMapViewDelegate {

    var places = [Place]()
    var mapView: GMSMapView!
    var markers = [GMSMarker]()
    var selectedPlaceId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        fetchData()
        navigationItem.title = "Map"
    }
    
    func fetchData() {
        Communication.sharedInstance.getAllPlaces { (places) in
            self.places = places
            self.setupMarkers()
        }
        
    }
    
    func setupMarkers() {
        for place in places {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            marker.title = place.name
            marker.snippet = "Hey, this is \(place.name)"
            marker.map = mapView
            self.markers.append(marker)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        var count = 0
        for marker1 in markers {
            
            if marker == marker1 {
                self.selectedPlaceId = places[count].id
                performSegue(withIdentifier: "placeDetails", sender: self)
            }
            count += 1
        }
    }

    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 33.5138, longitude: 36.2765, zoom: 11)
         mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! PlaceDetailsViewController
        destVC.placeId = selectedPlaceId
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
