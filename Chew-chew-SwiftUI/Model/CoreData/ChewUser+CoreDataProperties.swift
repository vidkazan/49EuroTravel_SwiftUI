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
	@NSManaged public var timestamp: Date?
	@NSManaged public var recentLocations: [Location]
	@NSManaged public var settings: Settings
	@NSManaged public var savedJourneyList: [SavedJourney]
}

extension ChewUser {
	static func updateWith(date : Date,using managedObjectContext: NSManagedObjectContext, user : ChewUser?) {
		guard let user = user else {return}
		user.timestamp = date
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save User: fialed to update User", nserror.localizedDescription)
		}
	}
	
	
	
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) {
		let launch = ChewUser(context: managedObjectContext)
		launch.timestamp = date
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("🔴 > save User: fialed to save new User", nserror.localizedDescription)
		}
	}
	
	static func basicFetchRequest(context : NSManagedObjectContext) -> ChewUser? {
		if let res = fetch(context: context) {
			return res
		}
		ChewUser.createWith(date: .now, using: context)
		return fetch(context: context)
	}
	
	static private func fetch(context : NSManagedObjectContext) -> ChewUser? {
		do {
			let res = try context.fetch(.init(entityName: "ChewUser")).first as? ChewUser
			if let res = res {
				return res
			}
			print("🔴 > basicFetchRequest User: context.fetch: result is empty")
			return nil
		} catch {
			print("🔴 > basicFetchRequest User: context.fetch error")
			return nil
		}
	}
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

// MARK: Generated accessors for savedJourneyList
extension ChewUser {

	@objc(addSavedJourneyListObject:)
	@NSManaged public func addToSavedJourneyList(_ value: SavedJourney)

	@objc(removeSavedJourneyListObject:)
	@NSManaged public func removeFromSavedJourneyList(_ value: SavedJourney)

	@objc(addSavedJourneyList:)
	@NSManaged public func addToSavedJourneyList(_ values: NSSet)

	@objc(removeSavedJourneyList:)
	@NSManaged public func removeFromSavedJourneyList(_ values: NSSet)

}
