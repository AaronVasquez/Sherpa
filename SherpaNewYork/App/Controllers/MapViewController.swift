import UIKit
import CoreLocation
import MapKit

import SDWebImage.UIImageView_WebCache

private let kDefaultZoomSpan = 0.01
private let kInitialDescriptionHeight: CGFloat = 66.0

private let annotationPinId = "annotationPinId"
private let pinImageName = "pin-icon"

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
    let userLocation = locations[0].coordinate
    self.userCoordinates = userLocation
    user.coordinates = userLocation

    let mapRegion = MKCoordinateRegionMake(userLocation, MKCoordinateSpanMake(kDefaultZoomSpan, kDefaultZoomSpan))
    mapView.setRegion(mapRegion, animated: false)
  }
  
}

extension MapViewController: MKMapViewDelegate {

  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }

    let venueAnnotation = annotation as! VenueAnnotation
    let venue = venueAnnotation.venue!

    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationPinId)
    if annotationView != nil {
      return annotationView
    } else {
      let pinImage = UIImage(named: pinImageName)?.imageWithRenderingMode(.AlwaysTemplate)
      let pinImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
      pinImageView.image = pinImage
      pinImageView.contentMode = .ScaleAspectFit
      pinImageView.tintColor = self.colorForType(venue.type)


      annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: annotationPinId)
      annotationView!.canShowCallout = false
      annotationView!.addSubview(pinImageView)
      pinImageView.center = annotationView!.center
      annotationView!.draggable = false
      return annotationView
    }
  }

  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    let venueAnnotation = view.annotation as! VenueAnnotation
    let venue = venueAnnotation.venue!

    // Highlight the selected venue.
    selectedVenue = venue
    self.changeColorForAnnotationView(view, color: UIColor.flatMintColor(), animated: true)
    centerMapOn(venue.coordinates)

    // Deselect all other annotations.
    mapView.selectedAnnotations
      .filter { return !$0.isEqual(venueAnnotation) }
      .forEach { mapView.deselectAnnotation($0, animated: true) }

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

  func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
    let venueAnnotation = view.annotation as! VenueAnnotation
    let venue = venueAnnotation.venue!

    self.changeColorForAnnotationView(view, color: self.colorForType(venue.type), animated: true)
  }

  private func changeColorForAnnotationView(annotationView: MKAnnotationView, color: UIColor, animated: Bool) {
    let animations = {
      annotationView.subviews
        .filter { return $0 is UIImageView }
        .forEach { $0.tintColor = color }
    }

    if (!animated) { return animations() }

    UIView.animateWithDuration(0.15,
      delay: 0.0,
      options: .CurveEaseInOut,
      animations: animations,
      completion: nil)
  }

}