import UIKit
import CoreLocation
import GoogleMaps

private let kDefaultLatitude: Double = 40.713
private let kDefaultLongitude: Double = -74.000
private let kDefaultZoomLevel: Float = 15.0

private let kPinIconCafe = "cafe_pin"
private let kPinIconRestaurant = "restaurant_pin"
private let kPinIconGrocery = "grocery_pin"
private let kPinIconDriving = "driving_pin"

private let kShowFilterSegue = "showVenueFilterViewController"

class MapViewController: UIViewController {
  
  let locationManager = CLLocationManager()
  let allVenues: [Venue] = VenueRepository.fetchVenues()
  var listView: UIView {
    return (storyboard?.instantiateViewControllerWithIdentifier("VenueList").view!)!
  }
  
  var listViewShown = false
  
  @IBOutlet weak var mapView: GMSMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.tabBar.hidden = false
    mapView.delegate = self
    
    initialLocationSetup()
    fetchLocation()
    
    reloadMap(nil)
  }
  
  private func reloadMap(filter: VenueFilter?) {
    mapView.clear()
    
    allVenues.filter({ venue -> Bool in
      if let filter = filter {
        if let type = filter.type {
          return type == venue.type
        }
      }
      return true;
    }).forEach({
      self.addMapPin($0)
    })
  }
  
  private func addMapPin(venue: Venue) {
    let mapPin = GMSMarker(position: venue.coordinates)
    mapPin.map = mapView
    mapPin.title = venue.name
    mapPin.snippet = venue.description
    mapPin.appearAnimation = kGMSMarkerAnimationPop
    mapPin.icon = pinForType(venue.type)
    mapPin.userData = venue
  }
  
  private func initialLocationSetup() {
    let userCoordinates = CLLocationCoordinate2D(latitude: kDefaultLatitude,
      longitude: kDefaultLongitude);
    centerMapOn(userCoordinates)
  }
  
  private func fetchLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  private func centerMapOn(userCoordinates: CLLocationCoordinate2D) {
    mapView.camera = GMSCameraPosition(target: userCoordinates, zoom: kDefaultZoomLevel,
      bearing: 0, viewingAngle: 0)
  }
  
  private func pinForType(type: VenueType) -> UIImage {
    switch type {
    case .Restuarant:
      return UIImage(named: "restaurant_pin")!
    case .Driving:
      return UIImage(named: "driving_pin")!
    }
  }
  
}

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    
    // TODO: Add condition for if the person is not in NYC so that it defaults to times square
    let userCoordinates = locations[0].coordinate
    centerMapOn(userCoordinates)
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
}

extension MapViewController: GMSMapViewDelegate {
  
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    if let navigationController = navigationController {
      let vc = storyboard?.instantiateViewControllerWithIdentifier("VenueDetailViewController")
        as? VenueDetailViewController
      vc!.venue = marker.userData as? Venue
      navigationController.pushViewController(vc!, animated: true)
    }
  }
  
}

extension MapViewController: VenueFilterDelegate {
  func filterDidChange(filter: VenueFilter) {
    reloadMap(filter)
  }
}