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

class RootMapViewController: UIViewController {

  let locationManager = CLLocationManager()
  let allVenues: [Venue] = VenueRepository.fetchVenues()
  var listViewController: UIViewController?
  var mapViewController: UIViewController?
  var listViewControllerShown = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tabBarController?.tabBar.hidden = false

    listViewController = storyboard?.instantiateViewControllerWithIdentifier("VenueList")
    mapViewController = storyboard?.instantiateViewControllerWithIdentifier("MapView")

    self.view.addSubview(listViewController!.view!)
    self.view.addSubview(mapViewController!.view!)
  }

  @IBAction func showFilterViewController(sender: AnyObject) {
    performSegueWithIdentifier(kShowFilterSegue, sender: mapViewController!)
  }

  @IBAction func showListViewController(sender: AnyObject) {
    if (listViewControllerShown) {
      UIView.transitionFromView(self.listViewController!.view!, toView: self.mapViewController!.view!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
    } else {
      UIView.transitionFromView(self.mapViewController!.view!, toView: self.listViewController!.view!, duration: 1, options: UIViewAnimationOptions.TransitionFlipFromRight, completion: nil)
    }
    listViewControllerShown = !listViewControllerShown
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == kShowFilterSegue) {
      let venueFilterVc = segue.destinationViewController as! VenueFilterViewController
      venueFilterVc.venueFilter = VenueFilter.init()
      venueFilterVc.filterDelegate = mapViewController! as! VenueFilterDelegate
    }
  }
}