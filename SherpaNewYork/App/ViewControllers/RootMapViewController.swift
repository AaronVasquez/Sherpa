import UIKit
import CoreLocation

internal let kDefaultLatitude: Double = 40.713
internal let kDefaultLongitude: Double = -74.000
internal let kDefaultZoomLevel: Float = 16.0

class RootMapViewController: UIViewController, CLLocationManagerDelegate {

  override func loadView() {
    self.view = RootMapView.init(frame: UIScreen.mainScreen().bounds,
                                 latitude: kDefaultLatitude,
                                 longitude: kDefaultLongitude,
                                 zoom: kDefaultZoomLevel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchLocation()
  }
  
  private func fetchLocation() {
    let locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    } else {
      // default to the coordinates of times square
    }
  }
    
  // MARK: - CLLocationManager
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let locationCoordinates:CLLocationCoordinate2D = manager.location!.coordinate
    print("locationCoordinates = \(locationCoordinates.latitude) , " +
          "\(locationCoordinates.longitude)")
    // pass coordinates to mapView
    manager.stopUpdatingLocation()
  }

}
