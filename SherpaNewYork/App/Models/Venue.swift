import CoreLocation
import Foundation

public struct Venue {
  let id: String
  let name: String
  let description: String
  let coordinates: CLLocationCoordinate2D
  let photoUrls: [NSURL]

  // TODO(aaron): Figure out the different categories (ie: Food, Entertainment, etc.).

  public init(id: String, name: String, description: String, lat: Double, long: Double,
              photoUrls: [NSURL]) {
    self.id = id
    self.name = name
    self.description = description
    self.coordinates = CLLocationCoordinate2DMake(lat, long)
    self.photoUrls = photoUrls
  }

}
