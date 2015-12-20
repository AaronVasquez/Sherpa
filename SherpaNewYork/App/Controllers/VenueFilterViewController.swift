import UIKit

public protocol VenueFilterDelegate {
  func filterDidChange(filter: VenueFilter)
}

public class VenueFilterViewController : UIViewController {

  // TODO: Inject this through the initializer.
  public var venueFilter: VenueFilter!
  public var filterDelegate: VenueFilterDelegate!

  @IBAction func didCancel(sender: UIBarButtonItem) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }

  @IBAction func showResturants(sender: AnyObject) {
    notifyAndDismissChange(VenueType.Restuarant)
  }

  @IBAction func showAll(sender: AnyObject) {
    notifyAndDismissChange(nil)
  }

  private func notifyAndDismissChange(type: VenueType?) {
    venueFilter.type = type
    filterDelegate.filterDidChange(venueFilter)
    self.dismissViewControllerAnimated(true, completion: nil)
  }

}