import UIKit
import CoreLocation

import DGRunkeeperSwitch
import SVProgressHUD

private let kDefaultLatitude: Double = 40.713
private let kDefaultLongitude: Double = -74.000
private let kDefaultZoomLevel: Float = 15.0

private let kShowFilterSegue = "showVenueFilterViewController"
private let kMapEmbedSegue = "MapEmbedSegue"
private let kListEmbedSegue = "ListEmbedSegue"
private let kVenueDetailSegue = "VenueDetailSegue"

class RootViewController: UIViewController {
  @IBOutlet weak var mapView: UIView!
  @IBOutlet weak var listView: UIView!

  @IBOutlet weak var mapListToggle: DGRunkeeperSwitch!
  
  private let locationManager = CLLocationManager()
  private var venueCollection: VenueCollection?

  private var chosenVenue: Venue?
  private var venueFilter = VenueFilter.init()
  private var listViewController: VenueListViewController?
  private var mapViewController: MapViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    SVProgressHUD.show()
    VenueRepository.fetchVenues { (venues) -> () in
      self.venueCollection = VenueCollection.init(venues: venues)
      self.reloadViews()

      SVProgressHUD.dismiss()
    }

    // Sets up the toggle view.
    mapListToggle.leftTitle = "Map"
    mapListToggle.rightTitle = "List"
    mapListToggle.backgroundColor = .flatMintColorDark()
    mapListToggle.selectedBackgroundColor = .flatWhiteColor()
    mapListToggle.titleColor = .whiteColor()
    mapListToggle.selectedTitleColor = .flatMintColor()
    mapListToggle.titleFont = .systemFontOfSize(14)
    mapListToggle.addTarget(self, action: Selector("toggleMapAndList:"), forControlEvents: .ValueChanged)
  }

  @IBAction func showFilterViewController(sender: AnyObject) {
    performSegueWithIdentifier(kShowFilterSegue, sender: mapViewController!)
  }

  @IBAction func toggleMapAndList(sender: DGRunkeeperSwitch) {
    let showMap = sender.selectedIndex == 0
    let fromView =  showMap ? listViewController!.view : mapViewController!.view
    let toView = showMap ? mapViewController!.view : listViewController!.view

    UIView.transitionFromView(fromView,
      toView: toView,
      duration: 0.05,
      options: UIViewAnimationOptions.TransitionCrossDissolve,
      completion: nil)
  }

  // TODO: We should pass in the data instead of relying on side effects.
  private func reloadViews() {
    mapViewController!.venueCollection = self.venueCollection
    listViewController!.venueCollection = self.venueCollection

    mapViewController!.reloadMap()
    listViewController!.reloadList()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == kShowFilterSegue) {
      //VenueFilterViewController
      let navController = segue.destinationViewController as! UINavigationController
      let venueFilterVc = navController.childViewControllers[0] as! VenueFilterViewController
      venueFilterVc.venueFilter = self.venueFilter
      venueFilterVc.filterDelegate = self
    }

    else if segue.identifier == kMapEmbedSegue {
      let mapVc = segue.destinationViewController as! MapViewController
      mapVc.delegate = self
      mapViewController = mapVc
    }
    
    else if segue.identifier == kListEmbedSegue {
      let listVc = segue.destinationViewController as! VenueListViewController
      listVc.delegate = self
      listViewController = listVc
    }
    
    else if segue.identifier == kVenueDetailSegue {
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
    venueCollection!.applyFilter(filter, location: userLocation)
    reloadViews()
  }
}