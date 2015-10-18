import UIKit

class RootMapView: UIView {
  
  var map: GMSMapView?

  init(frame: CGRect, coordinates: CLLocationCoordinate2D, zoom: Float) {
    super.init(frame: frame)
    
    let camera = GMSCameraPosition.cameraWithLatitude(
      coordinates.latitude, longitude:
      coordinates.longitude,
      zoom: kDefaultZoomLevel)
    
    map = GMSMapView.mapWithFrame(frame, camera: camera)
    addSubview(map!)
    
    addCurrentLocationMarker(coordinates)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("Don't use Storyboards, newb!")
  }
  
  private func addCurrentLocationMarker(coordinates: CLLocationCoordinate2D) {
    let marker = GMSMarker(position: coordinates)
    marker.title = "Current location"
    marker.map = map!
  }
}