import Foundation
import CoreLocation

public class VenueCollection {
  let allVenues = VenueRepository.fetchVenues()
  private(set) var filteredVenues: [Venue]

  required public init() {
    self.filteredVenues = self.allVenues;
  }

  func applyFilter(filter: VenueFilter, location: CLLocation) {
    filteredVenues = allVenues.filter({
      // Only filter if there are some types to be filtered.
      return filter.filterTypes.count > 0 ? filter.filterTypes.contains($0.type) : true;
    }).sort({ venueOne, venueTwo in
      switch (filter.sortBy) {
      case SortCriteria.Distance:
        let venueOneLocation = CLLocation.init(latitude: venueOne.coordinates.latitude,
                                               longitude: venueOne.coordinates.longitude)
        let venueTwoLocation = CLLocation.init(latitude: venueTwo.coordinates.latitude,
                                               longitude: venueTwo.coordinates.longitude)

        let venueOneDistance = venueOneLocation.distanceFromLocation(location)
        let venueTwoDistance = venueTwoLocation.distanceFromLocation(location)

        return venueOneDistance < venueTwoDistance
      case SortCriteria.Name:
        return venueOne.name > venueTwo.name
      }
    })
  }

}
