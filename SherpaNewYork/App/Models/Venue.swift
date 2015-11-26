import CoreLocation
import Foundation

public class Venue {
  let id: String
  let name: String
  let description: String
  let coordinates: CLLocationCoordinate2D
  let pin: String
  let photoUrls: [NSURL]
  
  required public init(id: String, name: String, description: String, coordinates: CLLocationCoordinate2D, pin: String, photoUrls: [NSURL]) {
    self.id = id
    self.name = name
    self.description = description
    self.coordinates = coordinates
    self.pin = pin
    self.photoUrls = photoUrls
  }

  // TODO(aaron): Figure out the different categories (ie: Food, Entertainment, etc.).
}
