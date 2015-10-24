import UIKit

class RootMapView: UIView {
  
  var map: GMSMapView?

  init(frame: CGRect, coordinates: CLLocationCoordinate2D, zoom: Float) {
    super.init(frame: frame)
    
    let camera = GMSCameraPosition.cameraWithLatitude(
      coordinates.latitude, longitude:
      coordinates.longitude,
      zoom: kDefaultZoomLevel)
    
    map = GMSMapView.mapWithFrame(frame, camera: camera)
    addMarkers(coordinates)
    addSubview(map!)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("Don't use Storyboards, newb!")
  }
  
  private func addMarkers(coordinates: CLLocationCoordinate2D) {
    var marker = GMSMarker(position: coordinates)
    marker.title = "Current location"
    marker.map = map!
    
    // make request to server that returns a bunch of places
    let jsonResponse: [Dictionary<String, AnyObject>] = [
      ["id": "1",
        "name": "Crumbs Bakery",
        "description": "Oven baked cookies and cupcakes",
        "icon_image": "cafe_pin",
        "latitude": 40.714,
        "longitude": -74.000
      ],
      ["id": "2",
        "name": "Shake Shack",
        "description": "Best burgers and french fries",
        "icon_image": "restaurant_pin",
        "latitude": 40.715,
        "longitude": -74.001
      ],
      ["id": "3",
        "name": "Whole Foods",
        "description": "Overpriced organic stuff",
        "icon_image": "grocery_or_supermarket_pin",
        "latitude": 40.716,
        "longitude": -74.000
      ],
      ["id": "4",
        "name": "Peter Luger",
        "description": "Big pieces of steak",
        "icon_image": "restaurant_pin",
        "latitude": 40.713,
        "longitude": -73.999
      ],
      ["id": "5",
        "name": "Century 21",
        "description": "Brand names for half the price",
        "icon_image": "driving_pin",
        "latitude": 40.712,
        "longitude": -73.998
      ]
    ]

    for place: Dictionary<String, AnyObject> in jsonResponse {
      let placeCoordinates = CLLocationCoordinate2D(latitude: place["latitude"] as! Double, longitude: place["longitude"] as! Double)
      var placeMarker = GMSMarker(position: placeCoordinates)
      placeMarker.title = place["name"] as! String
      placeMarker.snippet = place["description"] as! String
      placeMarker.icon = UIImage(named: place["icon_image"] as! String)
      placeMarker.appearAnimation = kGMSMarkerAnimationPop
      placeMarker.map = map!
    }
  }
}