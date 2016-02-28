import Foundation
import UIKit

import MHFacebookImageViewer.UIImageView_MHFacebookImageViewer
import SDWebImage.UIImageView_WebCache

class VenueDetailViewController: UIViewController {
  
  var venue: Venue?
  
  @IBOutlet weak var carousel: UICollectionView!
  @IBOutlet weak var shortDescription: UILabel!
  @IBOutlet weak var longDescription: UILabel!
  @IBOutlet weak var phoneNumber: UIButton!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.title = venue!.name
    self.longDescription.text = venue!.description
    self.shortDescription.text = venue!.shortDescription
    self.phoneNumber.setTitle(venue!.phoneNumber, forState: .Normal)
    
    carousel.delegate = self
    carousel.dataSource = self
  }
  
  @IBAction func phoneNumberTapped(sender: AnyObject) {
    if let number = NSURL(string: "tel://\(venue!.phoneNumber)") {
      UIApplication.sharedApplication().openURL(number)
    }
    
    
  }
}

extension VenueDetailViewController: UICollectionViewDataSource {

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return venue!.photoUrls.count
  }


  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! VenueDetailViewImageCell
    let imageUrl = venue!.photoUrls[indexPath.row]
    let imageView = cell.imageView

    imageView.sd_setImageWithURL(imageUrl) { (_, _, _, loadedUrl) -> Void in
      if imageUrl.isEqual(loadedUrl) {
        imageView.setupImageViewer()
      }
    }

    return cell
  }
}

extension VenueDetailViewController: UICollectionViewDelegate {

  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSizeMake(collectionView.bounds.size.width, 200)
  }
}


