import UIKit
import GoogleMaps

// TODO: Use an enum to map to the icons.
// TODO: Figure out what categories we need.
private let kPinIconCafe = "cafe_pin"
private let kPinIconRestaurant = "restaurant_pin"
private let kPinIconGrocery = "grocery_pin"
private let kPinIconDriving = "driving_pin"

class RootMapView: UIView {
  var mapView: GMSMapView

  required init(coder: NSCoder) { fatalError("NSCoding not supported") }

  // MARK: Public.

  required init(frame: CGRect, coordinates: CLLocationCoordinate2D, zoom: Float) {

    // Create mapView.
    let camera = GMSCameraPosition.cameraWithLatitude(
        coordinates.latitude,
        longitude: coordinates.longitude,
        zoom: zoom)
    mapView = GMSMapView.mapWithFrame(frame, camera: camera)!

    super.init(frame: frame)
    addSubview(mapView)
  }

  // TODO: Make the icon images an enum.
  func addMapPin(coordinates: CLLocationCoordinate2D, title: String, description: String) {
    let mapPin = GMSMarker(position: coordinates)
    mapPin.map = mapView
    mapPin.title = title
    mapPin.snippet = description
    mapPin.appearAnimation = kGMSMarkerAnimationPop
    mapPin.icon = UIImage(named: kPinIconRestaurant) // TODO: Make this dynamic
  }

}