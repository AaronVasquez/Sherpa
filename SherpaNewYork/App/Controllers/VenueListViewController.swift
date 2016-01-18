import Foundation
import UIKit

// TODO: Create a subclass to handle the cell.
private let kVenueCellIdentifier = "kVenueCellIdentifier"

class VenueListViewController: UIViewController {
  
  var delegate: VenueDetailDelegate?
  
  var selectedCellIndex = 0

  @IBOutlet weak var tableView: UITableView!

  // TODO: This should be shared between the map and list view.
  let venues = VenueRepository.fetchVenues()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.hidden = false
  }
}

extension VenueListViewController: UITableViewDataSource, UITableViewDelegate {
  
  // MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return venues.count
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.didPressVenueDetailButton(venues[indexPath.row])
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
    var newCell: UITableViewCell
    let venue = venues[indexPath.row]
      
    if let oldCell = tableView.dequeueReusableCellWithIdentifier(kVenueCellIdentifier) {
      newCell = oldCell
    } else {
      newCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: kVenueCellIdentifier)
    }
    
    newCell.textLabel!.text = venue.name
    
    return newCell
  }

}
