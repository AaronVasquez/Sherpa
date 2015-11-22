import Foundation
import UIKit

class RootTabBarController: UITabBarController {

  convenience init() {
    self.init()

    // TODO: These colors are yucky.
    tabBar.tintColor = UIColor.purpleColor()
    tabBar.barTintColor = UIColor.lightGrayColor()
    tabBar.translucent = false;
//
//    viewControllers = [
//      RootMapViewController(),
//      VenueNavigationController()
//    ]
  }

}