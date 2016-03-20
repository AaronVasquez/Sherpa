import Foundation
import UIKit
import MapKit

import MHFacebookImageViewer.UIImageView_MHFacebookImageViewer
import SDWebImage.UIImageView_WebCache
import SafariServices

private let annotationPinId = "annotationPinId"
private let pinImageName = "pin-icon"

class VenueDetailViewController: UIViewController {
  
  var venue: Venue?
  
  @IBOutlet weak var rootScrollView: UIScrollView!
  @IBOutlet weak var carousel: UICollectionView!
  @IBOutlet weak var shortDescription: UILabel!
  @IBOutlet weak var longDescription: UILabel!
  @IBOutlet weak var phoneNumber: UIButton!
  @IBOutlet weak var website: UIButton!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    mapView.delegate = self
    mapView.setCenterCoordinate(venue!.coordinates, animated: true)
    mapView.scrollEnabled = false
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    self.title = venue!.name
    self.longDescription.text = venue!.description
    self.shortDescription.text = venue!.shortDescription
    self.phoneNumber.setTitle(venue!.phoneNumber, forState: .Normal)
    self.website.setTitle(venue!.websiteUrl.absoluteString, forState: .Normal)
    self.pageControl.numberOfPages = venue!.photoUrls.count
    
    addMapPin(mapView, venue: venue!)
    carousel.delegate = self
    carousel.dataSource = self
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

//    rootScrollView.contentSize = CGSize(width: 320, height: self.mapView.bounds.origin.y+self.mapView.frame.height)
  }

  @IBAction func phoneNumberTapped(sender: AnyObject) {
    let alert = UIAlertController(title: venue!.name, message: "Call \(venue!.phoneNumber)", preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: "Call", style: UIAlertActionStyle.Default, handler: { action in
      if let number = NSURL(string: "tel://\(self.venue!.phoneNumber)") {
        UIApplication.sharedApplication().openURL(number)
      }
    }))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
    
    self.presentViewController(alert, animated: true, completion: nil)
  }
  
  @IBAction func websiteTapped(sender: AnyObject) {
    let svc = SFSafariViewController(URL: venue!.websiteUrl)
    self.presentViewController(svc, animated: true, completion: nil)
  }
  
  @IBAction func mapTapped(sender: AnyObject) {
    let placemark = MKPlacemark(coordinate: venue!.coordinates, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = venue!.name
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit]
    mapItem.openInMapsWithLaunchOptions(launchOptions)
  }
  
  private func addMapPin(map: MKMapView, venue: Venue) {
    let annotation = VenueAnnotation.init()
    annotation.coordinate = venue.coordinates
    annotation.venue = venue
    map.addAnnotation(annotation)

    let region = MKCoordinateRegionMakeWithDistance(venue.coordinates, 500, 500)
    map.setRegion(region, animated: false)
  }
  
  
}

extension VenueDetailViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    pageControl.currentPage = (self.carousel.indexPathsForVisibleItems().first?.row)!
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    pageControl.currentPage = (self.carousel.indexPathsForVisibleItems().first?.row)!
  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    pageControl.currentPage = (self.carousel.indexPathsForVisibleItems().first?.row)!
  }
}

extension VenueDetailViewController: MKMapViewDelegate {
  // This is copied and pasted :(
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation { return nil }

    let venueAnnotation = annotation as! VenueAnnotation
    let venue = venueAnnotation.venue!

    var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationPinId)
    if annotationView == nil {
      annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: annotationPinId)
    }

    let pinImage = UIImage(named: pinImageName)?.imageWithRenderingMode(.AlwaysTemplate)
    let pinImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    pinImageView.image = pinImage
    pinImageView.contentMode = .ScaleAspectFit
    pinImageView.tintColor = UIColor.flatMintColor()

    annotationView!.canShowCallout = false
    annotationView!.addSubview(pinImageView)
    annotationView!.frame = pinImageView.frame
    pinImageView.center = annotationView!.center
    annotationView!.draggable = false

    return annotationView
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


