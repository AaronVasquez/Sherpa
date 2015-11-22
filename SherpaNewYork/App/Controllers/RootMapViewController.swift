import UIKit
import CoreLocation
import GoogleMaps

private let kDefaultLatitude: Double = 40.713
private let kDefaultLongitude: Double = -74.000
private let kDefaultZoomLevel: Float = 16.0

private let kPinIconCafe = "cafe_pin"
private let kPinIconRestaurant = "restaurant_pin"
private let kPinIconGrocery = "grocery_pin"
private let kPinIconDriving = "driving_pin"

class RootMapViewController: UIViewController {
  
  @IBOutlet weak var mapView: GMSMapView!
  
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    fetchLocation()

    VenueRepository.fetchVenues { [unowned self] venues -> Void in
      for venue in venues {
        self.addMapPin(venue.coordinates, title: venue.name,
            description: venue.description)
      }
    }
  }
  
  func addMapPin(coordinates: CLLocationCoordinate2D, title: String, description: String) {
    let mapPin = GMSMarker(position: coordinates)
    mapPin.map = mapView
    mapPin.title = title
    mapPin.snippet = description
    mapPin.appearAnimation = kGMSMarkerAnimationPop
    mapPin.icon = UIImage(named: kPinIconRestaurant) // TODO: Make this dynamic
  }

  private func fetchLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  private func centerMapOn(userCoordinates: CLLocationCoordinate2D) {
    mapView.camera = GMSCameraPosition(target: userCoordinates, zoom: kDefaultZoomLevel, bearing: 0, viewingAngle: 0)
  }

}

// MARK: CLLocationManagerDelegate

extension RootMapViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    
    // TODO: Add condition for if the person is not in NYC so that it defaults to times square
    let userCoordinates = locations[0].coordinate
    centerMapOn(userCoordinates)
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
}