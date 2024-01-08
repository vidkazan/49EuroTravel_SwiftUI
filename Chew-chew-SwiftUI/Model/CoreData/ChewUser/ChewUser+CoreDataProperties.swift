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
	@NSManaged public var recentLocations: [Location]?
	@NSManaged public var settings: Settings?
	@NSManaged public var chewJourneys : [ChewJourney]?
}

extension ChewUser {
	
	static func createWith(date : Date,using managedObjectContext: NSManagedObjectContext) -> ChewUser? {
		print("> ⚡️ create \(Self.self) thread ",Thread.current)
		let user = ChewUser(context: managedObjectContext)
		user.timestamp = date

		let settings = Settings(context: managedObjectContext)
		let modes = TransportModes(context: managedObjectContext)

		settings.user = user
		modes.settings = settings

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
