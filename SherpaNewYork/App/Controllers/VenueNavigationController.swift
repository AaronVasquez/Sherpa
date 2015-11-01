import Foundation
import UIKit

class VenueNavigationController: UINavigationController {

  required convenience init() {
    self.init(nibName: nil, bundle: nil)

    // TODO: Make me pretty.
    navigationBar.barTintColor = UIColor.purpleColor()
    navigationBar.tintColor = UIColor.whiteColor()
    navigationBar.translucent = false

    pushViewController(VenueListViewController.init(), animated: false)
  }

}
