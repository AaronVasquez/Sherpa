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
  
  var venues: [Venue] {
    return VenueRepository.fetchVenues()
  }
  
  @IBOutlet weak var mapView: GMSMapView!
  
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    
    fetchLocation()

    for venue in venues {
      self.addMapPin(venue)
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.hidden = false
  }
  
  func addMapPin(venue: Venue) {
    let mapPin = GMSMarker(position: venue.coordinates)
    mapPin.map = mapView
    mapPin.title = venue.name
    mapPin.snippet = venue.description
    mapPin.appearAnimation = kGMSMarkerAnimationPop
    mapPin.icon = UIImage(named: venue.pin)
    mapPin.userData = venue
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

extension RootMapViewController: GMSMapViewDelegate {
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    if let navigationController = navigationController {
      let vc = storyboard?.instantiateViewControllerWithIdentifier("VenueDetailViewController") as? VenueDetailViewController
      vc!.venue = marker.userData as? Venue
      navigationController.pushViewController(vc!, animated: true)
    }
  }
  
}