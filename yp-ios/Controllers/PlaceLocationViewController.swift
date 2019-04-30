//
//  PlaceLocationViewController.swift
//  yp-ios
//
//  Created by Ibrahim Zakarya on 2/10/18.
//  Copyright © 2018 Ibrahim Zakarya. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON

class PlaceLocationViewController: UIViewController, GMSMapViewDelegate {

    var place: Place!
    
    var sourceLat = 0.0
    var sourceLong = 0.0
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        navigationItem.title = place.name
    }
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        if let currentLocation = mapView.myLocation {
            self.sourceLong = currentLocation.coordinate.longitude
            self.sourceLat = currentLocation.coordinate.latitude
        }
        drawPath()
    }
  
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: place.latitude, longitude: place.longitude, zoom: 14)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        marker.title = place.name
        marker.snippet = ""
        marker.map = mapView
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
    }
    
    func drawPath()
    {
        let origin = "\(sourceLat),\(sourceLong)"
        let destination = "\(place.latitude),\(place.longitude)"

        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBWe1XKAREXBWepdL4HvojoFV2FWFlqL7g"

        Alamofire.request(url).responseJSON { response in

            do {
            let json = try JSON(data: response.data!)
            let routes = json["routes"].arrayValue

            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 1
                polyline.map = self.mapView
            }
            } catch {
                
            }
        }
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
