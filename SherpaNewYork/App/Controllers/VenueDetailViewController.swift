import Foundation
import UIKit

class VenueDetailViewController: UIViewController {
  var venue: Venue?
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var bannerImage: UIImageView!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = false
    tabBarController?.tabBar.hidden = true

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
      if let data = NSData(contentsOfURL: self.venue!.photoUrls[0]) {
        let bannerImage = UIImage(data: data)
        dispatch_async(dispatch_get_main_queue(), {
          self.bannerImage.image = bannerImage
        })
      }
    }

    descriptionTextView.text = venue!.description
  }
  
  @IBAction func metroButtonTapped(sender: AnyObject) {
    print("Metro button tapped")
  }
  
}
