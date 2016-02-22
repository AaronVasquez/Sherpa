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
private let kMapEmbedSegue = "MapEmbedSegue"
private let kListEmbedSegue = "ListEmbedSegue"
private let kVenueDetailSegue = "VenueDetailSegue"

class RootViewController: UIViewController {
  @IBOutlet var mapView: UIView!
  @IBOutlet var listView: UIView!
  
  private let locationManager = CLLocationManager()
  private let venueCollection = VenueCollection.init();

  private var chosenVenue: Venue?
  private var venueFilter = VenueFilter.init()
  private var listViewController: VenueListViewController?
  private var mapViewController: MapViewController?

  @IBAction func showFilterViewController(sender: AnyObject) {
    performSegueWithIdentifier(kShowFilterSegue, sender: mapViewController!)
  }

  @IBAction func toggleMapAndList(sender: UISegmentedControl) {
    let showMap = sender.selectedSegmentIndex == 0
    let fromView =  showMap ? listViewController!.view : mapViewController!.view
    let toView = showMap ? mapViewController!.view : listViewController!.view

    UIView.transitionFromView(fromView,
      toView: toView,
      duration: 0.1,
      options: UIViewAnimationOptions.TransitionCrossDissolve,
      completion: nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == kShowFilterSegue) {
      //VenueFilterViewController
      let navController = segue.destinationViewController as! UINavigationController
      let venueFilterVc = navController.childViewControllers[0] as! VenueFilterViewController
      venueFilterVc.venueFilter = self.venueFilter
      venueFilterVc.filterDelegate = self
    }

    else if (segue.identifier == kMapEmbedSegue) {
      let mapVc = segue.destinationViewController as! MapViewController
      mapVc.delegate = self
      mapVc.venueCollection = self.venueCollection
      mapViewController = mapVc
    }
    
    else if (segue.identifier == kListEmbedSegue) {
      let listVc = segue.destinationViewController as! VenueListViewController
      listVc.delegate = self
      listVc.venueCollection = self.venueCollection
      listViewController = listVc
    }
    
    else if (segue.identifier == kVenueDetailSegue) {
      let venueDetailVc = segue.destinationViewController as! VenueDetailViewController
      venueDetailVc.venue = chosenVenue
    }
  }
}

extension RootViewController: VenueDetailDelegate {
  func didPressVenueDetailButton(venue: Venue) {
    chosenVenue = venue
    performSegueWithIdentifier(kVenueDetailSegue, sender: self)
  }
}

extension RootViewController: VenueFilterDelegate {
  func filterDidChange(filter: VenueFilter) {
    self.venueFilter = filter

    let userCoordinates = self.mapViewController?.userCoordinates;
    let userLocation = CLLocation.init(latitude: userCoordinates!.latitude,
                                       longitude: userCoordinates!.longitude)
    venueCollection.applyFilter(filter, location: userLocation)

    mapViewController!.reloadMap()
    listViewController!.reloadList()
  }
}