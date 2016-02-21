import Foundation
import UIKit

extension UIImageView {
  public func imageFromUrl(urlString: String) {
    if let url = NSURL(string: urlString) {
      let request = NSURLRequest(URL: url)
      NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        if let imageData = data as NSData? {
          self.image = UIImage(data: imageData)
        }
      })
    }
  }
}