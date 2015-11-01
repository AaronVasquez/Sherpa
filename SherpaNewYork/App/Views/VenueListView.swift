import Foundation
import UIKit

class VenueListView: UIView {
  let listView: UITableView

  required init?(coder aDecoder: NSCoder) { fatalError("Storyboard makes me sad.") }

  required init(frame: CGRect, listDataSource: protocol<UITableViewDataSource>,
      listDelegate: protocol<UITableViewDelegate>) {

    listView = UITableView.init(frame: frame)
    listView.dataSource = listDataSource
    listView.delegate = listDelegate

    super.init(frame: frame)

    addSubview(listView)
  }

}
