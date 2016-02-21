import Foundation
import UIKit

import SDWebImage

class VenueDetailViewController: UIViewController {
  var venue: Venue?
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var bannerImage: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = false
    tabBarController?.tabBar.hidden = true

    self.title = venue?.name
    self.bannerImage.sd_setImageWithURL(self.venue!.photoUrls[0])

    descriptionTextView.text = venue!.description
  }
  
  @IBAction func metroButtonTapped(sender: AnyObject) {
    print("Metro button tapped")
  }
  
}
