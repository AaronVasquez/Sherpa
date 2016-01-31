import Foundation
import UIKit

// TODO: Create a subclass to handle the cell.
private let kVenueCellIdentifier = "LMATableCell"
private let kVenueTableCellHeight: CGFloat = 200.0;

public class VenueListViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  var delegate: VenueDetailDelegate?
  var selectedCellIndex = 0

  var venueCollection: VenueCollection?

  override public func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override public func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.hidden = false
  }

  public func reloadList() {
    self.tableView.reloadData()
  }
}

extension VenueListViewController: UITableViewDataSource {
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return venueCollection!.filteredVenues.count
  }
  


  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
      -> UITableViewCell {
    let venue = venueCollection!.filteredVenues[indexPath.row]

    let venueTableCell =
      tableView.dequeueReusableCellWithIdentifier(kVenueCellIdentifier)! as! VenueTableViewCell

    venueTableCell.titleLabel.text = venue.name;

    // TODO: Figure out the gradient.
    // TODO: Cache the images.

    return venueTableCell
  }
}

extension VenueListViewController: UITableViewDelegate {

  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.didPressVenueDetailButton(venueCollection!.filteredVenues[indexPath.row])
  }

  public func tableView(tableView: UITableView, heightForRowAtIndexPath
                        indexPath: NSIndexPath) -> CGFloat {
    return kVenueTableCellHeight;
  }

}
