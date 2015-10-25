import CoreLocation
import Foundation

struct Venue {
  let name: String
  let description: String
  let location: CLLocation
  let photoUrls: [NSURL]

  // TODO(aaronvasquez): Figure out the different categories (ie: Food, Entertainment, etc.).

  init(name: String, description: String, location: CLLocation, photoUrls: [NSURL]) {
    self.name = name
    self.description = description
    self.location = location
    self.photoUrls = photoUrls
  }


}
