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
    }
    
    private func fetchLocation() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // default to the coordinates of times square
        }
    }
    
    private func loadMapView() {
        let camera = GMSCameraPosition.cameraWithLatitude(40.7131103,
                                                          longitude: -74.0006213,
                                                          zoom: 16)
        let mapView = GMSMapView.mapWithFrame(self.view.bounds, camera: camera)
        self.view.addSubview(mapView)
    }
    
  // MARK: - CLLocationManager
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let locationCoordinates:CLLocationCoordinate2D = manager.location!.coordinate
    print("locationCoordinates = \(locationCoordinates.latitude) , " +
          "\(locationCoordinates.longitude)")
    // pass coordinates to mapView
    locationManager.stopUpdatingLocation()
  }

}
