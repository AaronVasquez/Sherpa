import Foundation
import UIKit

class VenueDetailViewController: UIViewController {
  private var venue: Venue
  
  var rootView: VenueDetailView { return view as! VenueDetailView }

  required init?(coder aDecoder: NSCoder) { fatalError("Storyboards make me sad.") }

  required init(venue: Venue) {
    self.venue = venue  // This is ugly. Consider renaming the parameter?

    super.init(nibName: nil, bundle: nil)
    title = venue.name
  }

  override func loadView() {
    // Use autolayout.
    view = VenueDetailView(frame: UIScreen.mainScreen().bounds, targetController: self)
  }

  override func viewDidLoad() {
    self.rootView.addBannerImage(venue.photoUrls[0])
    self.rootView.addDescription(venue.description)
    self.rootView.addDirectionsButtons()
    self.rootView.setScrollViewHeight()
  }
  
  func metroButtonTapped(sender: UIButton!) {
    print("Metro button tapped")
  }
}
