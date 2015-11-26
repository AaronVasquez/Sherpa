import Foundation
import UIKit

class VenueDetailViewController: UIViewController {
  var venue: Venue?
  
  @IBOutlet weak var venueName: UILabel!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    venueName.text = venue!.name
  }
  
  func metroButtonTapped(sender: UIButton!) {
    print("Metro button tapped")
  }
}
