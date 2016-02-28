import CoreLocation
import Foundation

public enum VenueType: Int {
  case Restuarant = 1
  case Entertainment = 2
}

public class Venue {

  let id: String
  let name: String
  let description: String
  let shortDescription: String
  let price: Int
  let coordinates: CLLocationCoordinate2D
  let type: VenueType
  let phoneNumber: String
  let websiteUrl: NSURL
  let thumbnailUrl: NSURL
  let photoUrls: [NSURL]
  
  required public init(id: String, name: String, description: String, shortDescription: String, price: Int,
    coordinates: CLLocationCoordinate2D, type: Int, phoneNumber: String, websiteUrl: NSURL, thumbnailUrl: NSURL, photoUrls: [NSURL]) {
    self.id = id
    self.name = name
    self.description = description
    self.shortDescription = shortDescription
    self.price = price
    self.coordinates = coordinates
    self.type = VenueType(rawValue: type)!  // This can crash if we use an invalid Int.
    self.phoneNumber = phoneNumber
    self.websiteUrl = websiteUrl
    self.thumbnailUrl = thumbnailUrl
    self.photoUrls = photoUrls
  }
  
  public func dollarSigns() -> String {
    var result = ""
    for _ in 0..<self.price {
      result += "$"
    }
    return result
  }
}
