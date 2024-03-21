//
//  CDRecentSearch+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.01.24.
//
//

import Foundation
import CoreData


extension CDRecentSearch {
	@NSManaged public var id: String
	@NSManaged public var user: CDUser?
    @NSManaged public var searchDate: Date?
    @NSManaged public var depStop: CDLocation?
    @NSManaged public var arrStop: CDLocation?

}

extension CDRecentSearch : Identifiable {
	convenience init(
		user : CDUser,
		search : RecentSearchesViewModel.RecentSearch,
		using managedObjectContext: NSManagedObjectContext
	) {
		self.init(entity: CDRecentSearch.entity(), insertInto: managedObjectContext)
		self.id = search.stops.id
		self.searchDate = Date(timeIntervalSince1970: search.searchTS)
		let _ = CDLocation(
			context: managedObjectContext,
			stop: search.stops.departure,
			parent: .recentSearchDepStop(self)
		)
		let _ = CDLocation(
			context: managedObjectContext,
			stop: search.stops.arrival,
			parent: .recentSearchArrStop(self)
		)
		user.addToRecentSearches(self)
	}
}
