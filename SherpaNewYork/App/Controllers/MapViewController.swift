import UIKit
import CoreLocation

import GoogleMaps
import SDWebImage.UIImageView_WebCache

private let kDefaultZoomLevel: Float = 15.0

private let kShowFilterSegue = "showVenueFilterViewController"

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: GMSMapView!

  @IBOutlet weak var venueDescriptionButton: UIButton!
  @IBOutlet weak var venueDescriptionHeightConstraint: NSLayoutConstraint!

  @IBOutlet weak var venueDescriptionThumbnailImage: UIImageView!
  @IBOutlet weak var venueDescriptionNameLabel: UILabel!
  @IBOutlet weak var venueDescriptionCategoryLabel: UILabel!
  @IBOutlet weak var venueDescriptionDollars: UILabel!

  private let locationManager = CLLocationManager()

  var delegate: VenueDetailDelegate?

  var userCoordinates: CLLocationCoordinate2D = user.coordinates
  var venueCollection: VenueCollection?

  private var originalvenueDescriptionHeightConstraint:CGFloat?
  private var selectedVenue: Venue?
  
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
    selectedVenue = nil
    
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
  }
  
  private func addMapPin(venue: Venue) {
    let mapPin = GMSMarker(position: venue.coordinates)
    mapPin.map = mapView
    mapPin.title = venue.name
    mapPin.snippet = venue.description
    mapPin.appearAnimation = kGMSMarkerAnimationPop
    mapPin.icon = GMSMarker.markerImageWithColor(colorForType(venue.type))
    mapPin.userData = venue
  }
  
  private func initialLocationSetup() {
    let userCoordinates = user.coordinates
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

  private func colorForType(type: VenueType) -> UIColor {
    switch type {
    case .Restuarant:
      return UIColor.flatOrangeColor()
    case .Entertainment:
      return UIColor.flatBlueColor()
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
    user.coordinates = self.userCoordinates
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
    UIView.animateWithDuration(0.1,
        delay: 0,
        usingSpringWithDamping: 0.7,
        initialSpringVelocity: 0.0,
        options: .BeginFromCurrentState,
        animations: { self.view.layoutIfNeeded() },
        completion: { (_) -> Void in
          let venue = self.selectedVenue!

          self.venueDescriptionNameLabel.text = venue.name
          self.venueDescriptionCategoryLabel.text = venue.shortDescription
          self.venueDescriptionDollars.text = venue.dollarSigns()

          self.venueDescriptionThumbnailImage.sd_setImageWithURL(venue.thumbnailUrl)

          self.venueDescriptionHeightConstraint.constant =
              self.originalvenueDescriptionHeightConstraint!
          self.view.setNeedsUpdateConstraints()
          UIView.animateWithDuration(0.25,
              delay: 0.0,
              usingSpringWithDamping: 0.7,
              initialSpringVelocity: 0.0,
              options: .BeginFromCurrentState,
              animations: { self.view.layoutIfNeeded() },
              completion: nil)

        })
    return true
  }
}