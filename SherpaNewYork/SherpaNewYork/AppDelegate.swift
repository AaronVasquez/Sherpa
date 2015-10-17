import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    self.window?.rootViewController = self.rootViewController()
    return true
  }

  private func rootViewController() -> UIViewController {
    return UIViewController.init()
  }

}

