import Foundation
import CoreLocation

import SwiftyJSON

internal let kVenueRepositoryUrl = "VenuesData"

struct VenueRepository {

  // TODO: Add a progress callback.
  static func fetchVenues(completion: ([Venue]) -> ()){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
      let venues = buildVenues(loadVenueData())
      dispatch_async(dispatch_get_main_queue(), { completion(venues) })
    })
  }

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
        shortDescription: venue["shortDescription"].stringValue,
        price: venue["price"].intValue,
        coordinates: CLLocationCoordinate2D(latitude: venue["coordinates"]["lat"].doubleValue,
        longitude: venue["coordinates"]["long"].doubleValue),
        type: venue["type"].intValue,
        phoneNumber: venue["phoneNumber"].stringValue,
        websiteUrl: venue["websiteUrl"].URL!,
        thumbnailUrl: venue["thumbnailUrl"].URL!,
        photoUrls: photoUrls)
      
      venues.append(venue)
    }

    return venues
  }
}
