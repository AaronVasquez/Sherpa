import Foundation
import UIKit

import SDWebImage.UIImageView_WebCache

class VenueDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  var venue: Venue?
  
  @IBOutlet weak var carousel: UICollectionView!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.hidden = false
    tabBarController?.tabBar.hidden = true
    
    carousel.delegate = self
    carousel.dataSource = self
    self.title = venue?.name
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("image", forIndexPath: indexPath) as! VenueDetailViewImageCell
    
    cell.imageView.sd_setImageWithURL(venue!.photoUrls[indexPath.row])
    
    return cell
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return venue!.photoUrls.count
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      return CGSizeMake(collectionView.bounds.size.width, 200)
  }
  
  @IBAction func metroButtonTapped(sender: AnyObject) {
    print("Metro button tapped")
  }
  
}
