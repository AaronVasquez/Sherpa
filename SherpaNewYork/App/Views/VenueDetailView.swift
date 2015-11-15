import Foundation
import UIKit

class VenueDetailView: UIScrollView {
  var currentContentHeight: CGFloat = 0
  
  required init?(coder aDecoder: NSCoder) { fatalError("Storyboard makes me sad.") }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor.greenColor()
  }
  
  func addBannerImage(imageUrl: NSURL) {
    let heightOfImageView: CGFloat = 300
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: currentContentHeight, width: UIScreen.mainScreen().bounds.width, height: heightOfImageView))
    
    // TODO: Make this asynchronous
    // Nice to have: cache the image
    if let data = NSData(contentsOfURL: imageUrl) {
      imageView.image = UIImage(data: data)
    }
    
    addSubview(imageView)
    currentContentHeight += heightOfImageView
  }
  
  func addDescription(description: String) {
    let heightOfTextView: CGFloat = 500
    let textView = UITextView(frame: CGRect(x: 0, y: currentContentHeight, width: UIScreen.mainScreen().bounds.width, height: 500))
    
    textView.text = description
    textView.editable = false
    addSubview(textView)
    currentContentHeight += heightOfTextView
  }
  
  func addDirectionsButtons(target: UIViewController) {
    let heightOfButtons: CGFloat = 100
    let metroButton = UIButton(type: UIButtonType.System)
    
    metroButton.backgroundColor = UIColor.brownColor()
    metroButton.setTitle("Metro", forState: UIControlState.Normal)
    
    let center: CGFloat = UIScreen.mainScreen().bounds.width/2
    metroButton.frame = CGRectMake(center/2, currentContentHeight, center, heightOfButtons)
    
    metroButton.addTarget(target, action: "metroButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    addSubview(metroButton)
    currentContentHeight += heightOfButtons
  }
  
  func setScrollViewHeight() {
    contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: currentContentHeight)
  }
}