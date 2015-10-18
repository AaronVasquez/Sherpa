import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  lazy var window: UIWindow? = {
    var window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.makeKeyAndVisible()
    return window
  }()

  func application(application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    window!.rootViewController = MapViewController.init()
    return true
  }

}

