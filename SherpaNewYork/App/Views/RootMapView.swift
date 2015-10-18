import UIKit

class RootMapView: UIView {

  init(frame: CGRect, latitude: Double, longitude: Double, zoom: Float) {
    super.init(frame: frame)

    let camera = GMSCameraPosition.cameraWithLatitude(
        kDefaultLatitude, longitude: kDefaultLongitude, zoom: kDefaultZoomLevel)
    addSubview(GMSMapView.mapWithFrame(frame, camera: camera))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("Don't use Storyboards, newb!")
  }

}
