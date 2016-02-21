import Foundation
import UIKit

import SDWebImage.UIImageView_WebCache

class VenueDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var venue: Venue?
  
  @IBOutlet weak var carousel: UICollectionView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.title = venue?.name

    carousel.delegate = self
    carousel.dataSource = self
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! VenueDetailViewImageCell
    
    cell.imageView.sd_setImageWithURL(venue!.photoUrls[indexPath.row])
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return venue!.photoUrls.count
  }
  
  func collectionView(collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSizeMake(collectionView.bounds.size.width, 200)
  }
  
}
