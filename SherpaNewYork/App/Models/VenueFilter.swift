import Foundation

enum SortCriteria: Int {
  case Distance = 0, Name
}

public struct VenueFilter {
  var filterTypes: Set<VenueType>
  var sortBy: SortCriteria

  init() {
    self.filterTypes = Set<VenueType>()
    self.sortBy = SortCriteria.Distance
  }
}
