//
//  CDUser+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

extension CDUser {
	@NSManaged public var locations: Data?
	@NSManaged public var recentLocations: Set<CDLocation>?
	@NSManaged public var journeySettings: CDJourneySettings?
	@NSManaged public var appSettings: CDAppSettings?
	@NSManaged public var chewJourneys : Set<CDJourney>?
	@NSManaged public var chewRecentSearches : Set<CDRecentSearch>?
}

extension CDUser {
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) -> CDUser? {
		managedObjectContext.performAndWait {
			let user = CDUser(entity: CDUser.entity(), insertInto: managedObjectContext)

			let journeySettings = CDJourneySettings(entity: CDJourneySettings.entity(), insertInto: managedObjectContext)
			let appSettings = CDAppSettings(entity: CDAppSettings.entity(), insertInto: managedObjectContext)
			journeySettings.user = user
			appSettings.user = user

			do {
				try managedObjectContext.save()
				return user
			} catch {
				let nserror = error as NSError
				print("📕 > save User: failed to save new User", nserror.description, nserror.userInfo)
				return nil
			}
		}
	}
}

extension CDUser {

	@objc(addChewJourneysObject:)
	@NSManaged public func addToChewJourneys(_ value: CDJourney)

	@objc(removeChewJourneysObject:)
	@NSManaged public func removeFromChewJourneys(_ value: CDJourney)

	@objc(addChewJourneys:)
	@NSManaged public func addToChewJourneys(_ values: NSSet)

	@objc(removeChewJourneys:)
	@NSManaged public func removeFromChewJourneys(_ values: NSSet)

}

// MARK: Generated accessors for recentLocations
extension CDUser {

	@objc(addRecentLocationsObject:)
	@NSManaged public func addToRecentLocations(_ value: CDLocation)

	@objc(removeRecentLocationsObject:)
	@NSManaged public func removeFromRecentLocations(_ value: CDLocation)

	@objc(addRecentLocations:)
	@NSManaged public func addToRecentLocations(_ values: NSSet)

	@objc(removeRecentLocations:)
	@NSManaged public func removeFromRecentLocations(_ values: NSSet)

}

// MARK: Generated accessors for recentSearches
extension CDUser {

	@objc(addRecentSearchesObject:)
	@NSManaged public func addToRecentSearches(_ value: CDRecentSearch)

	@objc(removeRecentSearchesObject:)
	@NSManaged public func removeFromRecentSearches(_ value: CDRecentSearch)

	@objc(addRecentSearches:)
	@NSManaged public func addToRecentSearches(_ values: NSSet)

	@objc(removeRecentSearches:)
	@NSManaged public func removeFromRecentSearches(_ values: NSSet)

}

