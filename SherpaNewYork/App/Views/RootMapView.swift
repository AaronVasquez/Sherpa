import UIKit
import GoogleMaps

class RootMapView: UIView {
  
  var coordinates: CLLocationCoordinate2D
  var map: GMSMapView?

  init(frame: CGRect, coordinates: CLLocationCoordinate2D, zoom: Float) {
    self.coordinates = coordinates
    
    super.init(frame: frame)

    addMap()
    addFilters()
    addPurpleButton()
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("Don't use Storyboards, newb!")
  }
  
  func showFilters(sender: UIButton!) {
    println("Filter clicked")
  }
  
  func showList(sender: UIButton!) {
    println("Button clicked")
  }
  
  private func addPurpleButton() {
    var purpleButton = UIButton()
    purpleButton.backgroundColor = UIColor.purpleColor()
    purpleButton.frame = CGRectMake(0, frame.size.height-100, frame.size.width, 100)
    purpleButton.setTitle("Other recommendations >", forState: UIControlState.Normal)
    purpleButton.addTarget(self, action: "showList:", forControlEvents: UIControlEvents.TouchUpInside)
    addSubview(purpleButton)
  }
  
  private func addMap() {
    let camera = GMSCameraPosition.cameraWithLatitude(
      coordinates.latitude, longitude:
      coordinates.longitude,
      zoom: kDefaultZoomLevel)
    
    map = GMSMapView.mapWithFrame(frame, camera: camera)
    addMarkers(coordinates)
    addSubview(map!)
  }
  
  private func addFilters() {
    var filterButton = UIButton()
    let filterImage = UIImage(named: "filter-1")
    filterButton.frame = CGRectMake(frame.size.width-100, 30, 70, 70)
    filterButton.setImage(filterImage, forState: UIControlState.Normal)
    filterButton.addTarget(self, action: "showFilters:", forControlEvents: UIControlEvents.TouchUpInside)
    addSubview(filterButton)
  }
  
  private func addMarkers(coordinates: CLLocationCoordinate2D) {
    var marker = GMSMarker(position: coordinates)
    marker.title = "Current location"
    marker.map = map!
    
    // make request to server that returns a bunch of places
    let jsonResponse: [Dictionary<String, AnyObject>] = [
      [
        "id": "1",
        "name": "Crumbs Bakery",
        "description": "Oven baked cookies and cupcakes",
        "icon_image": "cafe_pin",
        "latitude": 40.714,
        "longitude": -74.000
      ],
      [
        "id": "2",
        "name": "Shake Shack",
        "description": "Best burgers and french fries",
        "icon_image": "restaurant_pin",
        "latitude": 40.715,
        "longitude": -74.001
      ],
      [
        "id": "3",
        "name": "Whole Foods",
        "description": "Overpriced organic stuff",
        "icon_image": "grocery_or_supermarket_pin",
        "latitude": 40.716,
        "longitude": -74.000
      ],
      [
        "id": "4",
        "name": "Peter Luger",
        "description": "Big pieces of steak",
        "icon_image": "restaurant_pin",
        "latitude": 40.713,
        "longitude": -73.999
      ],
      [
        "id": "5",
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