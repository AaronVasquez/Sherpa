import CoreLocation
import Foundation

private let kDefaultLatitude: Double = 40.713
private let kDefaultLongitude: Double = -74.000

struct User {
  var coordinates: CLLocationCoordinate2D
  
  func distanceFrom(location: CLLocationCoordinate2D) -> String {
    let currentLocation = CLLocation.init(latitude: coordinates.latitude,
      longitude: coordinates.longitude)
    let destinationLocation = CLLocation.init(latitude: location.latitude,
      longitude: location.longitude)
    
    let distance = currentLocation.distanceFromLocation(destinationLocation)
    return "\(String(format: "%.1f", distance / 1609.34)) miles"
  }
}

var user = User(coordinates: CLLocationCoordinate2D(latitude: kDefaultLatitude, longitude: kDefaultLongitude))