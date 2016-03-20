import Foundation
import UIKit

import MHFacebookImageViewer.UIImageView_MHFacebookImageViewer
import SDWebImage.UIImageView_WebCache
import SafariServices

class VenueDetailViewController: UIViewController {
  
  var venue: Venue?
  
  @IBOutlet weak var rootScrollView: UIScrollView!
  @IBOutlet weak var carousel: UICollectionView!
  @IBOutlet weak var shortDescription: UILabel!
  @IBOutlet weak var longDescription: UILabel!
  @IBOutlet weak var phoneNumber: UIButton!
  @IBOutlet weak var website: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.title = venue!.name
    self.longDescription.text = venue!.description
    self.shortDescription.text = venue!.shortDescription
    self.phoneNumber.setTitle(venue!.phoneNumber, forState: .Normal)
    self.website.setTitle(venue!.websiteUrl.absoluteString, forState: .Normal)
    self.pageControl.numberOfPages = venue!.photoUrls.count
    
    carousel.delegate = self
    carousel.dataSource = self
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    rootScrollView.contentSize = CGSize(width: 320, height: 1000)//rootStackView.bounds.size
  }

  @IBAction func phoneNumberTapped(sender: AnyObject) {
    if let number = NSURL(string: "tel://\(venue!.phoneNumber)") {
      UIApplication.sharedApplication().openURL(number)
    }
  }
  
  @IBAction func websiteTapped(sender: AnyObject) {
    let svc = SFSafariViewController(URL: venue!.websiteUrl)
    self.presentViewController(svc, animated: true, completion: nil)
  }
}

extension VenueDetailViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    pageControl.currentPage = (self.carousel.indexPathsForVisibleItems().first?.row)!
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


