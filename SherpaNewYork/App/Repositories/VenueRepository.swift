import Foundation
import SwiftyJSON
import CoreLocation

internal let kVenueRepositoryUrl = "VenuesData"

struct VenueRepository {

  static func fetchVenues(completion: [Venue] -> Void) {
    // TODO(aaron): Process this data in a background thread so the main thread is not blocked.
    completion(buildVenues(loadVenueData()))
  }

  // TODO(aaron): Check if this actually works.
  private static func loadVenueData() -> JSON {
    let filePath = NSBundle.mainBundle().pathForResource(kVenueRepositoryUrl, ofType: "json")!
    let jsonData = NSData(contentsOfFile: filePath)!
    return JSON(data: jsonData)
  }

  private static func buildVenues(jsonDictionary: JSON) -> [Venue] {
    var venues: [Venue] = []

    for (_, venue):(String, JSON) in jsonDictionary["venues"] {
      let photoUrls: [NSURL] = venue["photoUrls"].arrayValue.map { (JSON urlString) -> NSURL in
        NSURL(string: urlString.stringValue)!
      }
      
      let venue = Venue.init(id: venue["id"].stringValue,
        name: venue["name"].stringValue,
        description: venue["description"].stringValue,
        coordinates: CLLocationCoordinate2D(latitude: venue["coordinates"]["lat"].doubleValue,
          longitude: venue["coordinates"]["long"].doubleValue),
        photoUrls: photoUrls)
      
      venues.append(venue)
    }

    return venues
  }
}
