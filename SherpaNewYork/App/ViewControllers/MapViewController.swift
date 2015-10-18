import UIKit
import CoreLocation

// TODO(Edmund): Get a new API key and don't expose it publically on Github.
internal let kGoogleMapsApiKey = "AIzaSyCeL1NT-6T38o-fI-PyH5zinxygymdlrMw"

internal let kDefaultZoomLevel: Float = 16.0
internal let kDefaultLatitude: Double = 40.713
internal let kDefaultLongitude: Double = -74.000

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
  let locationManager = CLLocationManager()

    override func viewDidLoad() {
      super.viewDidLoad()

      fetchLocation()
      loadMapView()

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
      GMSServices.provideAPIKey(kGoogleMapsApiKey)
      let camera = GMSCameraPosition.cameraWithLatitude(kDefaultLatitude,
                                                        longitude: kDefaultLongitude,
                                                        zoom: kDefaultZoomLevel)
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
