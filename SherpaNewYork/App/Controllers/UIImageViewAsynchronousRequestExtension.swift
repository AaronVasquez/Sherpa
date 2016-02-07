//
//  UIImageViewAsynchronousRequestExtension.swift
//  SherpaNewYork
//
//  Created by Edmund Mai on 2/7/16.
//  Copyright © 2016 Aaron Vasquez. All rights reserved.
//

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