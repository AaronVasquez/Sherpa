import Foundation
import UIKit

class RootTabBarController: UITabBarController {

  convenience init() {
    // OMG, Apple makes it so hard to override init without using storyboards :(.
    self.init(nibName: nil, bundle: nil)

    // TODO: These colors are yucky.
    tabBar.tintColor = UIColor.purpleColor()
    tabBar.translucent = false;

    // TODO: Use an actual viewController.
    let listVC = UIViewController.init()
    listVC.view.backgroundColor = UIColor.redColor()
    listVC.title = "List"

    viewControllers = [
      RootMapViewController.init(),
      listVC,
    ]
  }

}