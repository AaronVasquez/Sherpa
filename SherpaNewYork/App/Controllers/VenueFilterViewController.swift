import UIKit

public protocol VenueFilterDelegate {
  func filterDidChange(filter: VenueFilter)
}

public class VenueFilterViewController : UIViewController {

  // TODO: Inject this through the initializer.
  public var venueFilter: VenueFilter! {
    didSet {
      reloadViewFromFilterChange(venueFilter)
    }
  }
  public var filterDelegate: VenueFilterDelegate!

  @IBOutlet weak var sortByControl: UISegmentedControl!
  @IBOutlet weak var restuarantSwitch: UISwitch!
  @IBOutlet weak var entertainmentSwitch: UISwitch!

  override public func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    reloadViewFromFilterChange(venueFilter)
  }

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

  // Private

  private func reloadViewFromFilterChange(newFilter: VenueFilter) {
    if (view == nil) {
      return
    }

    sortByControl.selectedSegmentIndex = newFilter.sortBy.rawValue

    newFilter.filterTypes.forEach({
      switch ($0) {
        case VenueType.Restuarant:
          restuarantSwitch.setOn(true, animated: false)
        case VenueType.Entertainment:
          entertainmentSwitch.setOn(true, animated: false)
      }
    })
  }

}