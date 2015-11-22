import UIKit
import GoogleMaps

// TODO(Edmund): Get a new API key and don't expose it publically on Github.
internal let kGoogleMapsApiKey = "AIzaSyCeL1NT-6T38o-fI-PyH5zinxygymdlrMw"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    GMSServices.provideAPIKey(kGoogleMapsApiKey)
    return true
  }

}