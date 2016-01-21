import UIKit
import CoreLocation
import GoogleMaps

private let kDefaultLatitude: Double = 40.713
private let kDefaultLongitude: Double = -74.000
private let kDefaultZoomLevel: Float = 15.0

private let kPinIconCafe = "cafe_pin"
private let kPinIconRestaurant = "restaurant_pin"
private let kPinIconGrocery = "grocery_pin"
private let kPinIconDriving = "driving_pin"

private let kShowFilterSegue = "showVenueFilterViewController"

class MapViewController: UIViewController {
  
  var delegate: VenueDetailDelegate?
  
  let locationManager = CLLocationManager()
  var userCoordinates = CLLocationCoordinate2DMake(kDefaultLatitude, kDefaultLongitude)
  let allVenues: [Venue] = VenueRepository.fetchVenues()  // This should be shared with root.

  var originalBottomViewHeightConstraint:CGFloat?
  var selectedVenue: Venue?
  
  var firstDescriptionShown = false

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var descriptionView: UIView!
  @IBOutlet weak var descriptionViewButton: UIButton!
  @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var venueNameLabel: UILabel!
  
  @IBOutlet weak var newthingheight: NSLayoutConstraint!
  @IBOutlet weak var newthing: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.tabBar.hidden = false
    mapView.delegate = self
    
    initialLocationSetup()
    fetchLocation()
    
    let venueFilter = VenueFilter.init()
    reloadMap(venueFilter)
  }
  
  override func viewWillAppear(animated: Bool) {

    self.descriptionViewButton.alpha = 1.0
    self.descriptionViewButton.backgroundColor = UIColor.clearColor()
    
    if (selectedVenue == nil) {
      // Record the original constraint size
      self.originalBottomViewHeightConstraint = self.bottomViewHeightConstraint.constant
      
      // Set the constraint to zero
      self.bottomViewHeightConstraint.constant = 0.0
      newthingheight.constant = 0
    }

  }
  
  func reloadMap(filter: VenueFilter) {
    mapView.clear()

    let userLocation = CLLocation.init(latitude: self.userCoordinates.latitude,
                                       longitude: self.userCoordinates.longitude)

    allVenues.filter({
      // Only filter if there are some types to be filtered.
      return filter.filterTypes.count > 0 ? filter.filterTypes.contains($0.type) : true;
    }).sort({ venueOne, venueTwo in
      switch (filter.sortBy) {
        case SortCriteria.Distance:
          let venueOneLocation = CLLocation.init(latitude: venueOne.coordinates.latitude,
                                                 longitude: venueOne.coordinates.longitude)
          let venueTwoLocation = CLLocation.init(latitude: venueTwo.coordinates.latitude,
                                                 longitude: venueTwo.coordinates.longitude)
          return venueOneLocation.distanceFromLocation(userLocation) <
              venueTwoLocation.distanceFromLocation(userLocation)
        case SortCriteria.Name:
          return venueOne.name > venueTwo.name
      }
    }).forEach({
      self.addMapPin($0)
    })
  }
  
  private func addMapPin(venue: Venue) {
    let mapPin = GMSMarker(position: venue.coordinates)
    mapPin.map = mapView
    mapPin.title = venue.name
    mapPin.snippet = venue.description
    mapPin.appearAnimation = kGMSMarkerAnimationPop
    mapPin.icon = pinForType(venue.type)
    mapPin.userData = venue
  }
  
  private func initialLocationSetup() {
    let userCoordinates = CLLocationCoordinate2D(latitude: kDefaultLatitude,
      longitude: kDefaultLongitude);
    centerMapOn(userCoordinates)
  }
  
  private func fetchLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  private func centerMapOn(userCoordinates: CLLocationCoordinate2D) {
    mapView.camera = GMSCameraPosition(target: userCoordinates, zoom: kDefaultZoomLevel,
      bearing: 0, viewingAngle: 0)
  }
  
  private func pinForType(type: VenueType) -> UIImage {
    switch type {
    case .Restuarant:
      return UIImage(named: "restaurant_pin")!
    case .Entertainment:
      return UIImage(named: "driving_pin")!
    }
  }
  
  @IBAction func descriptionTapped(sender: AnyObject) {
    self.delegate?.didPressVenueDetailButton(selectedVenue!)
  }
}

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    
    // TODO: Add condition for if the person is not in NYC so that it defaults to times square
    self.userCoordinates = locations[0].coordinate
    centerMapOn(userCoordinates)
    mapView.myLocationEnabled = true
    mapView.settings.myLocationButton = true
  }
  
}

extension MapViewController: GMSMapViewDelegate {
  
  func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
    selectedVenue = marker.userData as? Venue
    
    self.venueNameLabel.text = selectedVenue!.name
    
    if firstDescriptionShown {
      newthingheight.constant = 66
      self.bottomViewHeightConstraint.constant = 0
    } else {
      
      newthingheight.constant = 0
      self.bottomViewHeightConstraint.constant = self.originalBottomViewHeightConstraint!
    }
    
    firstDescriptionShown = !firstDescriptionShown

    
    
    self.view.setNeedsUpdateConstraints()

    UIView.animateWithDuration(0.5) { () -> Void in
      self.view.layoutIfNeeded()
    }

    return true
  }
  
}