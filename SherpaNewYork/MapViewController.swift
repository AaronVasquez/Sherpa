//
//  MapViewController.swift
//  SherpaNewYork
//
//  Created by Edmund Mai on 10/17/15.
//  Copyright (c) 2015 Aaron Vasquez. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchLocation()
        loadMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchLocation() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            NSLog("done")
        } else {
            NSLog("rejected")
            // default to the coordinates of times square
        }
    }
    
    private func loadMapView() {
        let camera = GMSCameraPosition.cameraWithLatitude(-33.8683, longitude: 151.2086, zoom: 16)
        let mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera)
        self.view.addSubview(mapView)
    }
    
    // MARK: - CLLocationManager
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locationCoordinates:CLLocationCoordinate2D = manager.location.coordinate
        NSLog("current location = \(locationCoordinates.latitude) , \(locationCoordinates.longitude)")
    }

}
