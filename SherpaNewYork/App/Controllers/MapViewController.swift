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
  var venueCollection: VenueCollection?

  var originalvenueDescriptionHeightConstraint:CGFloat?
  var selectedVenue: Venue?
  
  var firstDescriptionShown = false

  @IBOutlet weak var mapView: GMSMapView!

  @IBOutlet weak var venueDescriptionButton: UIButton!
  @IBOutlet weak var venueDescriptionNameLabel: UILabel!
  @IBOutlet weak var venueDescriptionCategoryLabel: UILabel!
  @IBOutlet weak var venueDescriptionHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var venueDescriptionThumbnailImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.tabBar.hidden = false
    mapView.delegate = self
    
    initialLocationSetup()
    fetchLocation()

    reloadMap()
  }
  
  override func viewWillAppear(animated: Bool) {

    self.venueDescriptionButton.backgroundColor = UIColor.clearColor()
    
    if (selectedVenue == nil) {
      // Record the original constraint size
      originalvenueDescriptionHeightConstraint = 66 //venueDescriptionHeightConstraint.constant
      // Set the constraint to zero
      venueDescriptionHeightConstraint.constant = 0
    }

  }
  
  func reloadMap() {
    hideDescriptions()
    mapView.clear()

    venueCollection!.filteredVenues.forEach({
      self.addMapPin($0)
    })
  }
  
  func hideDescriptions() {
    venueDescriptionHeightConstraint.constant = 0
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

    mapView.animateToLocation(selectedVenue!.coordinates)
    
    venueDescriptionHeightConstraint.constant = 0
    self.view.setNeedsUpdateConstraints()
    UIView.animateWithDuration(0.25,
        delay: 0,
        usingSpringWithDamping: 0.75,
        initialSpringVelocity: 0.0,
        options: .BeginFromCurrentState,
        animations: { () -> Void in
          self.view.layoutIfNeeded()
        },
        completion: { (success) -> Void in
          self.venueDescriptionNameLabel.text = self.selectedVenue!.name
          self.venueDescriptionCategoryLabel.text = self.selectedVenue!.pinDescription()
          self.venueDescriptionThumbnailImage.imageFromUrl(self.selectedVenue!.thumbnailUrl)
        })
    
    venueDescriptionHeightConstraint.constant = originalvenueDescriptionHeightConstraint!
    self.view.setNeedsUpdateConstraints()
    UIView.animateWithDuration(0.25,
      delay: 0.25,
      usingSpringWithDamping: 0.75,
      initialSpringVelocity: 0.0,
      options: .BeginFromCurrentState,
      animations: { () -> Void in
        self.view.layoutIfNeeded()
      },
      completion: nil)
    

    return true
  }
  
}


extension UIImageView {
  public func imageFromUrl(urlString: String) {
    if let url = NSURL(string: urlString) {
      let request = NSURLRequest(URL: url)
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        if let imageData = data as NSData? {
          self.image = UIImage(data: imageData)
        }
      })
    }
  }
}