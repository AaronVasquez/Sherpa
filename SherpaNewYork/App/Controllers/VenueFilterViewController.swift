import UIKit

public protocol VenueFilterDelegate {
  func filterDidChange(filter: VenueFilter)
}

public class VenueFilterViewController : UIViewController {

  // TODO: Inject this through the initializer.
  public var venueFilter: VenueFilter!
  public var filterDelegate: VenueFilterDelegate!

  @IBOutlet weak var restuarantSwitch: UISwitch!
  @IBOutlet weak var entertainmentSwitch: UISwitch!

  // Sort

  @IBAction func sortCriteriaDidChange(sender: UISegmentedControl) {
    venueFilter.sortBy = SortCriteria(rawValue: sender.selectedSegmentIndex)!
  }

  // Filter

  @IBAction func filterUnselectAll(sender: AnyObject) {
    restuarantSwitch.setOn(false, animated:true)
    entertainmentSwitch.setOn(false, animated:true)

    venueFilter.filterTypes.removeAll()
  }

  @IBAction func filterOnRestaurants(sender: UISwitch) {
    if (sender.on) {
      venueFilter.filterTypes.insert(VenueType.Restuarant)
    } else {
      venueFilter.filterTypes.remove(VenueType.Restuarant)
    }
  }

  @IBAction func filterOnEntertainment(sender: UISwitch) {
    if (sender.on) {
      venueFilter.filterTypes.insert(VenueType.Entertainment)
    } else {
      venueFilter.filterTypes.remove(VenueType.Entertainment)
    }
  }

  // Apply Filter

  @IBAction func applyFilter(sender: AnyObject) {
    filterDelegate.filterDidChange(venueFilter);
    self.dismissViewControllerAnimated(true, completion: nil)
  }

}