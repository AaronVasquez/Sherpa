import UIKit

class VenueFilterViewController : UIViewController {
  
  @IBAction func didCancel(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func showResturants(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func showAll(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}