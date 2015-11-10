import UIKit
import CoreLocation

private let kDefaultLatitude: Double = 40.713
private let kDefaultLongitude: Double = -74.000
private let kDefaultZoomLevel: Float = 16.0

class RootMapViewController: UIViewController, CLLocationManagerDelegate {
  // Argh swift doesn't let us declare the view's Class.
  var rootView: RootMapView { return view as! RootMapView }

  convenience init() {
    self.init(nibName: nil, bundle: nil)
    title = "Map"
  }

  override func loadView() {
    fetchLocation()
    // TODO: Use autolayout.
    view = RootMapView(frame: UIScreen.mainScreen().bounds,
        coordinates: CLLocationCoordinate2DMake(kDefaultLatitude, kDefaultLongitude),
        zoom: kDefaultZoomLevel)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    VenueRepository.fetchVenues { [unowned self] venues -> Void in
      for venue in venues {
        self.rootView.addMapPin(venue.coordinates, title: venue.name,
            description: venue.description)
      }
    }
  }
  
  private func fetchLocation() {
    let locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.startUpdatingLocation()
    } else {
      // default to the coordinates of times square
    }
  }
    
  // MARK: CLLocationManagerDelegate

  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userCoordinates = manager.location!.coordinate
    manager.stopUpdatingLocation()

    // TODO: Center to userCoordinates
    self.rootView.addMapPin(userCoordinates, title: "Current Location", description: "This is me")
  }

}
