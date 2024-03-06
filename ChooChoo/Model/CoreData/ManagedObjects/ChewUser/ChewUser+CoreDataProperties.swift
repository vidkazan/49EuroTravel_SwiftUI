//
//  ChewUser+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

extension ChewUser {
	@NSManaged public var recentLocations: Set<Location>?
	@NSManaged public var chooSettings: ChooSettings?
	@NSManaged public var chewJourneys : Set<ChewJourney>?
	@NSManaged public var chewRecentSearches : Set<ChewRecentSearch>?
}

extension ChewUser {
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) -> ChewUser? {
		managedObjectContext.performAndWait {
//			print("> ⚡️ create \(Self.self) thread ",Thread.current)
			let user = ChewUser(entity: ChewUser.entity(), insertInto: managedObjectContext)

			let settings = ChooSettings(entity: ChooSettings.entity(), insertInto: managedObjectContext)
			let modes = TransportModes(entity: TransportModes.entity(), insertInto: managedObjectContext)
			settings.user = user
			modes.chooSettings = settings

			do {
				try managedObjectContext.save()
				return user
			} catch {
				let nserror = error as NSError
				print("📕 > save User: failed to save new User", nserror.localizedDescription, nserror.userInfo)
				return nil
			}
		}
	}
}



// MARK: Generated accessors for chewJourneys
extension ChewUser {
	@objc(addChewJourneysObject:)
	@NSManaged public func addToChewJourneys(_ value: ChewJourney)

	@objc(removeChewJourneysObject:)
	@NSManaged public func removeFromChewJourneys(_ value: ChewJourney)

	@objc(addChewJourneys:)
	@NSManaged public func addToChewJourneys(_ values: NSSet)

	@objc(removeChewJourneys:)
	@NSManaged public func removeFromChewJourneys(_ values: NSSet)

}

// MARK: Generated accessors for recentLocations
extension ChewUser {

	@objc(addRecentLocationsObject:)
	@NSManaged public func addToRecentLocations(_ value: Location)

	@objc(removeRecentLocationsObject:)
	@NSManaged public func removeFromRecentLocations(_ value: Location)

	@objc(addRecentLocations:)
	@NSManaged public func addToRecentLocations(_ values: NSSet)

	@objc(removeRecentLocations:)
	@NSManaged public func removeFromRecentLocations(_ values: NSSet)

}

// MARK: Generated accessors for recentSearches
extension ChewUser {

	@objc(addRecentSearchesObject:)
	@NSManaged public func addToRecentSearches(_ value: ChewRecentSearch)

	@objc(removeRecentSearchesObject:)
	@NSManaged public func removeFromRecentSearches(_ value: ChewRecentSearch)

	@objc(addRecentSearches:)
	@NSManaged public func addToRecentSearches(_ values: NSSet)

	@objc(removeRecentSearches:)
	@NSManaged public func removeFromRecentSearches(_ values: NSSet)

}

extension ChewUser : Identifiable {

}

