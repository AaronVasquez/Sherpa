import UIKit

import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Remove ugly hairline.
    UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
    UINavigationBar.appearance().shadowImage = UIImage()

    // Sets up SVProgressHUD
    SVProgressHUD.setBackgroundColor(UIColor.flatMintColor())
    SVProgressHUD.setForegroundColor(UIColor.whiteColor())
    SVProgressHUD.setRingThickness(4.0)

    return true
  }

}