import Foundation
import UIKit

// TODO: Create a subclass to handle the cell.
private let kVenueCellIdentifier = "kVenueCellIdentifier"

class VenueListViewController: UIViewController,
    UITableViewDataSource, UITableViewDelegate {

  // Argh swift doesn't let us declare the view's Class.
  var rootView: VenueListView { return view as! VenueListView }

  // TODO: This should be shared between the map and list view.
  var venues: [Venue]? {
    didSet {
      rootView.listView.reloadData()
    }
  }

  convenience init() {
    self.init(nibName: nil, bundle: nil)
    title = "Venues"
    venues = nil // Why do I need to do this...
  }

  override func loadView() {
    // TODO: Use autolayout.
    view = VenueListView.init(frame: UIScreen.mainScreen().bounds, listDataSource: self,
        listDelegate: self)
  }

  // MARK: ViewController Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    VenueRepository.fetchVenues { [unowned self] venues -> Void in
      self.venues = venues
    }
  }

  // MARK: UITableViewDataSource

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let venues = venues {
      return venues.count
    } else {
      return 0;
    }
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
      -> UITableViewCell {
    var tableCell: UITableViewCell
    if let oldCell = tableView.dequeueReusableCellWithIdentifier(kVenueCellIdentifier) {
      tableCell = oldCell
    } else {
      tableCell = UITableViewCell.init(style: .Default, reuseIdentifier: kVenueCellIdentifier)
    }

    let venue = venues![indexPath.row]

    tableCell.textLabel?.text = venue.name

    return tableCell
  }

  // MARK: UITableViewDelegate

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let venue = venues![indexPath.row]

    if let navViewController = self.navigationController {
      navViewController.pushViewController(VenueDetailViewController.init(venue: venue),
                                           animated: true)
    } else {
      // Present this modally?
    }
  }

}
