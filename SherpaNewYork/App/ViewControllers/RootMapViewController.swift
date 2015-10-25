import UIKit
import CoreLocation

internal let kDefaultLatitude: Double = 40.713
internal let kDefaultLongitude: Double = -74.000
internal let kDefaultZoomLevel: Float = 16.0

class RootMapViewController: UIViewController, CLLocationManagerDelegate {
  
  var userCoordinates = CLLocationCoordinate2DMake(kDefaultLatitude, kDefaultLongitude)
  
  override func loadView() {
    fetchLocation()
    view = RootMapView.init(frame: UIScreen.mainScreen().bounds,
      coordinates: userCoordinates, zoom: kDefaultZoomLevel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
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
    
  // MARK: CLLocationManagerDelegate

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    userCoordinates = manager.location!.coordinate
    manager.stopUpdatingLocation()
  }

}
