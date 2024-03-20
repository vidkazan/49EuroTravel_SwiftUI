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
	@NSManaged public var recentLocations: Set<CDLocation>?
	@NSManaged public var chooSettings: CDSettings?
	@NSManaged public var chewJourneys : Set<CDJourney>?
	@NSManaged public var chewRecentSearches : Set<ChewRecentSearch>?
}

extension CDUser {
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) -> CDUser? {
		managedObjectContext.performAndWait {
			let user = CDUser(entity: CDUser.entity(), insertInto: managedObjectContext)

			let settings = CDSettings(entity: CDSettings.entity(), insertInto: managedObjectContext)
			let modes = CDTransportModes(entity: CDTransportModes.entity(), insertInto: managedObjectContext)
			settings.user = user
			modes.chooSettings = settings

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
	@objc(addSavedLocationsObject:)
	@NSManaged public func addToSavedLocations(_ value: CDLocation)

	@objc(removeSavedLocationsObject:)
	@NSManaged public func removeFromSavedLocations(_ value: CDLocation)

	@objc(addSavedLocations:)
	@NSManaged public func addToSavedLocations(_ values: NSSet)

	@objc(removeSavedLocations:)
	@NSManaged public func removeFromSavedLocations(_ values: NSSet)

}

// MARK: Generated accessors for chewJourneys
extension CDUser {
	@objc(addCDJourneysObject:)
	@NSManaged public func addToCDJourneys(_ value: CDJourney)

	@objc(removeCDJourneysObject:)
	@NSManaged public func removeFromCDJourneys(_ value: CDJourney)

	@objc(addCDJourneys:)
	@NSManaged public func addToCDJourneys(_ values: NSSet)

	@objc(removeCDJourneys:)
	@NSManaged public func removeFromCDJourneys(_ values: NSSet)

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
	@NSManaged public func addToRecentSearches(_ value: ChewRecentSearch)

	@objc(removeRecentSearchesObject:)
	@NSManaged public func removeFromRecentSearches(_ value: ChewRecentSearch)

	@objc(addRecentSearches:)
	@NSManaged public func addToRecentSearches(_ values: NSSet)

	@objc(removeRecentSearches:)
	@NSManaged public func removeFromRecentSearches(_ values: NSSet)

}

extension CDUser : Identifiable {

}

