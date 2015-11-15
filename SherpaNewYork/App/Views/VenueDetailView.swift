import Foundation
import UIKit

class VenueDetailView: UIScrollView {
  var target: VenueDetailViewController
  
  required init?(coder aDecoder: NSCoder) { fatalError("Storyboard makes me sad.") }
  
  required init(frame: CGRect, targetController: VenueDetailViewController) {
    target = targetController
    
    super.init(frame: frame)
    
    bounces = false
    backgroundColor = UIColor.greenColor()
  }
  
  func addBannerImage(imageUrl: NSURL) {
    let imageView = UIImageView(frame: CGRect(x: 0, y: currentContentHeight(), width: UIScreen.mainScreen().bounds.width, height: 300))
    // TODO: Make this asynchronous
    // Nice to have: cache the image
    if let data = NSData(contentsOfURL: imageUrl) {
      imageView.image = UIImage(data: data)
    }
    
    addSubview(imageView)
  }
  
  func addDescription(description: String) {
    let textView = UITextView(frame: CGRect(x: 0, y: currentContentHeight(), width: UIScreen.mainScreen().bounds.width, height: 500))
    
    textView.text = description
    textView.editable = false
    addSubview(textView)
  }
  
  func addDirectionsButtons() {
    let metroButton = UIButton(type: UIButtonType.System)
    
    metroButton.backgroundColor = UIColor.brownColor()
    metroButton.setTitle("Metro", forState: UIControlState.Normal)
    
    let center: CGFloat = UIScreen.mainScreen().bounds.width/2
    metroButton.frame = CGRectMake(center/2, currentContentHeight(), center, 100)
    
    metroButton.addTarget(target, action: "metroButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    addSubview(metroButton)
  }
  
  func setScrollViewHeight() {
    contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: currentContentHeight())
  }
  
  private func currentContentHeight() -> CGFloat {
    return subviews.reduce(0) { $0 + $1.bounds.height }
  }
}