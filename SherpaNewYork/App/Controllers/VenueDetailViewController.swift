import Foundation
import UIKit

class VenueDetailViewController: UIViewController {
  private var venue: Venue

  required init?(coder aDecoder: NSCoder) { fatalError("Storyboards make me sad.") }

  required init(venue: Venue) {
    self.venue = venue  // This is ugly. Consider renaming the parameter?

    super.init(nibName: nil, bundle: nil)
    title = venue.name
  }

  override func loadView() {
    // Use autolayout.
    view = VenueDetailView(frame: UIScreen.mainScreen().bounds)
  }

}
