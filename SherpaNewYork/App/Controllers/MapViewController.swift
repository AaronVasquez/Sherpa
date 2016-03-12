import UIKit
import CoreLocation
import MapKit

import SDWebImage.UIImageView_WebCache

private let kDefaultZoomSpan = 0.01
private let kInitialDescriptionHeight: CGFloat = 66.0

private let kShowFilterSegue = "showVenueFilterViewController"

class VenueAnnotation: MKPointAnnotation {
  var venue: Venue?
}

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!

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
    mapView.showsUserLocation = true
    
    initialLocationSetup()
    fetchLocation()

    reloadMap()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.venueDescriptionButton.backgroundColor = UIColor.clearColor()
    if (selectedVenue == nil) {
      originalvenueDescriptionHeightConstraint = kInitialDescriptionHeight
      venueDescriptionHeightConstraint.constant = 0
    }
  }
  
  func reloadMap() {
    hideDescriptions()
    clearMapView(mapView)

    if let venues = venueCollection?.filteredVenues {
      venues.forEach({ self.addMapPin(mapView, venue: $0) })
    }

  }
  
  func hideDescriptions() {
    venueDescriptionHeightConstraint.constant = 0
    selectedVenue = nil
    
    self.view.setNeedsUpdateConstraints()
    self.view.layoutIfNeeded()
  }

  // TODO: Extend the mapView instead of doing this.
  private func clearMapView(mapView: MKMapView) {
    mapView.removeAnnotations(mapView.annotations.filter({
      return !$0.isEqual(mapView.userLocation)
    }))
  }
  
  private func addMapPin(map: MKMapView, venue: Venue) {
    let annotation = VenueAnnotation.init()
    annotation.coordinate = venue.coordinates
    annotation.venue = venue
    map.addAnnotation(annotation)
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
  
  private func centerMapOn(coordinate: CLLocationCoordinate2D) {
    mapView.setCenterCoordinate(coordinate, animated: true)
  }

// TODO: Customize the annotation pin.
//  private func colorForType(type: VenueType) -> UIColor {
//    switch type {
//    case .Restuarant:
//      return UIColor.flatOrangeColor()
//    case .Entertainment:
//      return UIColor.flatBlueColor()
//    }
//  }

  @IBAction func descriptionTapped(sender: AnyObject) {
    self.delegate?.didPressVenueDetailButton(selectedVenue!)
  }
}

extension MapViewController: CLLocationManagerDelegate {
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    
    // TODO: Add condition for if the person is not in NYC so that it defaults to times square
    let userLocation = locations[0].coordinate
    self.userCoordinates = userLocation
    user.coordinates = userLocation

    let mapRegion = MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(kDefaultZoomSpan, kDefaultZoomSpan))
    mapView.setRegion(mapRegion, animated: false)
  }
  
}

extension MapViewController: MKMapViewDelegate {

  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    let venueAnnotation = view.annotation as! VenueAnnotation
    let venue = venueAnnotation.venue!
    selectedVenue = venue

    centerMapOn(venue.coordinates)

    venueDescriptionHeightConstraint.constant = -10.0
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
  }
}