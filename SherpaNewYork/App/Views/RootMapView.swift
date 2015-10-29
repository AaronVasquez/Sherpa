import UIKit
import GoogleMaps

// TODO: Use an enum to map to the icons.
// TODO: Figure out what categories we need.
private let kPinIconCafe = "cafe_pin"
private let kPinIconRestaurant = "restaurant_pin"
private let kPinIconGrocery = "grocery_pin"
private let kPinIconDriving = "driving_pin"

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
    print("Filter clicked")
  }
  
  func showList(sender: UIButton!) {
    print("Button clicked")
  }
  
  private func addPurpleButton() {
    let purpleButton = UIButton()
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
    let filterButton = UIButton()
    let filterImage = UIImage(named: "filter-1")
    filterButton.frame = CGRectMake(frame.size.width-100, 30, 70, 70)
    filterButton.setImage(filterImage, forState: UIControlState.Normal)
    filterButton.addTarget(self, action: "showFilters:", forControlEvents: UIControlEvents.TouchUpInside)
    addSubview(filterButton)
  }
  
  private func addMarkers(coordinates: CLLocationCoordinate2D) {
    let marker = GMSMarker(position: coordinates)
    marker.title = "Current location"
    marker.map = map

    // TODO: This should not be done in the view! Clean this up!!!
    VenueRepository.fetchVenues {[unowned self] (venues) -> Void in

      for venue in venues {
        let placeMarker = GMSMarker(position: venue.coordinates)
        placeMarker.title = venue.name
        placeMarker.snippet = venue.description
        placeMarker.icon = UIImage(named: kPinIconRestaurant) // TODO: Make this dynamic.
        placeMarker.appearAnimation = kGMSMarkerAnimationPop
        placeMarker.map = self.map!
        print("balls to you")
      }
    }

  }

}