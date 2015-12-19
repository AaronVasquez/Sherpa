import CoreLocation
import Foundation

public enum VenueType: Int {
  case Restuarant = 1
  case Driving = 2
}

public class Venue {

  let id: String
  let name: String
  let description: String
  let coordinates: CLLocationCoordinate2D
  let type: VenueType
  let photoUrls: [NSURL]
  
  required public init(id: String, name: String, description: String, coordinates: CLLocationCoordinate2D, type: Int, photoUrls: [NSURL]) {
    self.id = id
    self.name = name
    self.description = description
    self.coordinates = coordinates
    self.type = VenueType(rawValue: type)!  // This can crash if we use an invalid Int.
    self.photoUrls = photoUrls
  }

  // TODO(aaron): Figure out the different categories (ie: Food, Entertainment, etc.).
}
