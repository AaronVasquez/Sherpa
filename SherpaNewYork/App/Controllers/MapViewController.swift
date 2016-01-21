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

  var originalfirstDescriptionHeightConstraint:CGFloat?
  var selectedVenue: Venue?
  
  var firstDescriptionShown = false

  @IBOutlet weak var mapView: GMSMapView!

  @IBOutlet weak var firstDescriptionButton: UIButton!
  @IBOutlet weak var secondDescriptionButton: UIButton!
  
  @IBOutlet weak var firstVenueNameLabel: UILabel!
  @IBOutlet weak var secondVenueNameLabel: UILabel!
  
  @IBOutlet weak var firstDescriptionHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var secondDescriptionHeightConstraint: NSLayoutConstraint!
  
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

    self.firstDescriptionButton.backgroundColor = UIColor.clearColor()
    self.secondDescriptionButton.backgroundColor = UIColor.clearColor()
    
    if (selectedVenue == nil) {
      // Record the original constraint size
      originalfirstDescriptionHeightConstraint = firstDescriptionHeightConstraint.constant
      
      // Set the constraint to zero
      firstDescriptionHeightConstraint.constant = 0.0
      secondDescriptionHeightConstraint.constant = 0
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
  
  func hideDescriptions() {
    firstDescriptionHeightConstraint.constant = 0
    secondDescriptionHeightConstraint.constant = 0
    firstDescriptionShown = false
    
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
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
    let newChosenVenue = marker.userData as? Venue
    if (selectedVenue != nil && selectedVenue!.name == newChosenVenue!.name) {
      return true
    }
    
    selectedVenue = newChosenVenue
    
    if firstDescriptionShown {
      secondDescriptionHeightConstraint.constant = originalfirstDescriptionHeightConstraint!
      secondVenueNameLabel.text = selectedVenue!.name
      firstDescriptionHeightConstraint.constant = 0
    } else {
      firstVenueNameLabel.text = selectedVenue!.name
      firstDescriptionHeightConstraint.constant = originalfirstDescriptionHeightConstraint!
      secondDescriptionHeightConstraint.constant = 0
    }

    firstDescriptionShown = !firstDescriptionShown
    
    self.view.setNeedsUpdateConstraints()
    UIView.animateWithDuration(0.5) { () -> Void in
      self.view.layoutIfNeeded()
    }

    return true
  }
  
}