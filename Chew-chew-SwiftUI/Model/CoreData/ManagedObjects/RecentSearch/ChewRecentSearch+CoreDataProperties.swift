//
//  ChewRecentSearch+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.01.24.
//
//

import Foundation
import CoreData


extension ChewRecentSearch {
	@NSManaged public var id: String
	@NSManaged public var user: ChewUser?
    @NSManaged public var searchDate: Date?
    @NSManaged public var depStop: Location?
    @NSManaged public var arrStop: Location?

}

extension ChewRecentSearch : Identifiable {
	convenience init(user : ChewUser,stops : DepartureArrivalPair,using managedObjectContext: NSManagedObjectContext) {
			self.init(context: managedObjectContext)
			self.id = stops.id
			self.user = user
			self.searchDate = .now
			let _ = Location(context: managedObjectContext, stop: stops.departure, parent: .recentSearchDepStop(self))
			let _ = Location(context: managedObjectContext, stop: stops.arrival,parent: .recentSearchArrStop(self))
		}
}
