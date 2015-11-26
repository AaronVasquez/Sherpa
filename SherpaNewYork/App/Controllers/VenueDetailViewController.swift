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
    
    if let data = NSData(contentsOfURL: venue!.photoUrls[0]) {
      bannerImage.image = UIImage(data: data)
    }
    
    descriptionTextView.text = venue!.description
  }
  
  @IBAction func metroButtonTapped(sender: AnyObject) {
    print("Metro button tapped")
  }
  
}
