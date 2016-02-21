import Foundation
import UIKit

import SDWebImage
import iCarousel

class VenueDetailViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
  var venue: Venue?
  
  
  @IBOutlet weak var carousel: iCarousel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    carousel.type = iCarouselType.Linear
    carousel.delegate = self
    carousel.dataSource = self
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = false
    tabBarController?.tabBar.hidden = true

//    carousel.reloadData()
    self.title = venue?.name
  }
  
  func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
    return venue!.photoUrls.count
  }
  
  func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
    return value
  }

  func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
    var imageView: UIImageView
    
    if (view == nil) {
      imageView = UIImageView(frame:CGRect(x:0, y:0, width:UIScreen.mainScreen().bounds.width, height:300))
      imageView.sd_setImageWithURL(venue!.photoUrls[index])
    } else {
      imageView = view as! UIImageView
    }

//    print((venue!.photoUrls[index]))
    return imageView
  }
  
}
