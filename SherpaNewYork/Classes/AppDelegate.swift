import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
  internal let googleMapsApiKey = "AIzaSyCeL1NT-6T38o-fI-PyH5zinxygymdlrMw"

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      GMSServices.provideAPIKey(googleMapsApiKey)
      self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
      self.window!.rootViewController = self.rootViewController()
      self.window!.makeKeyAndVisible()
      return true
  }

  private func rootViewController() -> UIViewController {
      return MapViewController.init()
  }

}

