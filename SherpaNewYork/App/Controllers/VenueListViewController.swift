import Foundation
import UIKit

// TODO: Create a subclass to handle the cell.
private let kVenueCellIdentifier = "kVenueCellIdentifier"

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

extension VenueListViewController: UITableViewDataSource, UITableViewDelegate {
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return venueCollection!.filteredVenues.count
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.didPressVenueDetailButton(venueCollection!.filteredVenues[indexPath.row])
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
    var newCell: UITableViewCell
    let venue = venueCollection!.filteredVenues[indexPath.row]
      
    if let oldCell = tableView.dequeueReusableCellWithIdentifier(kVenueCellIdentifier) {
      newCell = oldCell
    } else {
      newCell = UITableViewCell(style: UITableViewCellStyle.Default,
                      reuseIdentifier: kVenueCellIdentifier)
    }
    
    newCell.textLabel!.text = venue.name
    
    return newCell
  }

}
