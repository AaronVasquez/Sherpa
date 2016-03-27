import Foundation
import UIKit

import ChameleonFramework.UIColor_Chameleon
import SDWebImage.UIImageView_WebCache

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

  public func reloadList() {
    self.tableView.reloadData()
  }
}

extension VenueListViewController: UITableViewDataSource {
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let venues = venueCollection?.filteredVenues {
      return venues.count
    } else {
      return 0
    }
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
      -> UITableViewCell {
    let venue = venueCollection!.filteredVenues[indexPath.row]

    let venueTableCell =
        tableView.dequeueReusableCellWithIdentifier(kVenueCellIdentifier)! as! VenueTableViewCell
    let informationView = venueTableCell.informationContainerView

    venueTableCell.titleLabel.text = venue.name
    venueTableCell.descriptionLabel.text = "\(venue.shortDescription) - \(venue.dollarSigns())"
    venueTableCell.subdescriptionLabel.text = user.distanceFrom(venue.coordinates)
    venueTableCell.informationContainerView.backgroundColor =
        UIColor.init(gradientStyle:.TopToBottom,
                     withFrame: informationView.bounds,
                     andColors: [UIColor.clearColor(), UIColor.init(white: 0.0, alpha: 0.5)])

    venueTableCell.bannerImageView.sd_setImageWithURL(venue.photoUrls[0])

    return venueTableCell
  }
}

extension VenueListViewController: UITableViewDelegate {

  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.delegate?.didPressVenueDetailButton(venueCollection!.filteredVenues[indexPath.row])
  }

  public func tableView(tableView: UITableView, heightForRowAtIndexPath
                        indexPath: NSIndexPath) -> CGFloat {
    return kVenueTableCellHeight
  }

}
