import CoreLocation
import Foundation

public struct Venue {
  let id: String
  let name: String
  let description: String
  let coordinates: CLLocationCoordinate2D
  let pin: String
  let photoUrls: [NSURL]

  // TODO(aaron): Figure out the different categories (ie: Food, Entertainment, etc.).
}
