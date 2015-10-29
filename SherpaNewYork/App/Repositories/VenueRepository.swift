import Foundation

internal let kVenueRepositoryUrl = "VenuesData"

struct VenueRepository {

  static func fetchVenues(completion: [Venue] -> Void) {
    // TODO(aaron): Process this data in a background thread so the main thread is not blocked.
    completion(buildVenues(loadVenueData()))
  }

  // TODO(aaron): Check if this actually works.
  private static func loadVenueData() -> NSDictionary {
    let filePath = NSBundle.mainBundle().pathForResource(kVenueRepositoryUrl, ofType: "json")!
    let jsonData = NSData(contentsOfFile: filePath)!
    return try! NSJSONSerialization.JSONObjectWithData(jsonData, options: []) as! NSDictionary
  }

  private static func buildVenues(jsonDictionary: NSDictionary) -> [Venue] {
    var venues: [Venue] = []

    for venueDictionary in jsonDictionary["venues"] as! [NSDictionary] {
      let coords = venueDictionary["coordinates"] as! NSDictionary
      let photos = venueDictionary["photoUrls"] as! [String]
      let photoUrls: [NSURL] = photos.map({ (NSString urlString) -> NSURL in
        NSURL(string: urlString)!
      })

      let venue =
          Venue.init(id: venueDictionary["id"] as! String,
                     name: venueDictionary["name"] as! String,
                     description: venueDictionary["description"] as! String,
                     lat: coords["lat"] as! Double,
                     long: coords["long"] as! Double,
                     photoUrls: photoUrls)
      venues.append(venue)
    }

    return venues
  }
}
