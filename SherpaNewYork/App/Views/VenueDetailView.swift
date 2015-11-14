import Foundation
import UIKit

class VenueDetailView: UIScrollView {
  required init?(coder aDecoder: NSCoder) { fatalError("Storyboard makes me sad.") }

  override init(frame: CGRect) {
    super.init(frame: frame)
    contentSize = CGSize(width: frame.width, height: frame.height*2)

    backgroundColor = UIColor.greenColor()
  }
  
  func addBannerImage(imageUrl: NSURL) {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 300))
    
    // TODO: Make this asynchronous
    // Nice to have: cache the image
    if let data = NSData(contentsOfURL: imageUrl) {
      imageView.image = UIImage(data: data)
    }
    
    addSubview(imageView)
  }
}