//
//  SavedJourney+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension SavedJourney {
    @NSManaged public var journeyRef: String
    @NSManaged public var arrivalStop: Location?
    @NSManaged public var departureStop: Location?
	@NSManaged public var user: ChewUser
	@NSManaged public var isActive: Bool
}

extension SavedJourney {
//	static func getRefs(savedJourneys : [SavedJourney]?) -> [String]? {
//		if let res = savedJourneys {
//			let stops = res.map { elem in
//				elem.journeyRef
//			}
//			return stops
//		}
//		return nil
//	}
	
	static func basicFetchRequest(context : NSManagedObjectContext) -> [SavedJourney]? {
		return fetch(context: context)
	}
	
	static private func fetch(context : NSManagedObjectContext) -> [SavedJourney]? {
		do {
			let res = try context.fetch(.init(entityName: "SavedJourney")) as? [SavedJourney]
			if let res = res {
				print("📗 > basicFetchRequest SavedJourney")
				return res
			}
			print("🔴 > basicFetchRequest SavedJourney: context.fetch: result is empty")
			return nil
		} catch {
			print("🔴 > basicFetchRequest SavedJourney: context.fetch error")
			return nil
		}
	}
	
	static func createWith(
		user : ChewUser?,
		depStop : Stop?,
		arrStop : Stop?,
		ref : String,
		using managedObjectContext: NSManagedObjectContext,
		in object : [SavedJourney]?
	) {
		guard object?.contains(where: { elem in elem.journeyRef == ref}) != true else {
			return
		}
		guard let user = user else {
			print("🔴 > create SavedJourney: user is nil")
			return
		}
		let journey = SavedJourney(context: managedObjectContext)
		journey.isActive = false
		journey.journeyRef = ref
		journey.user = user

		do {
			try managedObjectContext.save()
			print("📙 > create SavedJourney: created new SavedJourney")
		} catch {
			let nserror = error as NSError
			print("🔴 > create SavedJourney: ", nserror.localizedDescription)
		}
	}
	
	static func delete(deleteRef : String,in objects : [SavedJourney]?, context : NSManagedObjectContext) {
		guard let objects = objects else {
			print("🔴 > delete SavedJourneys: object is nil")
			return
		}
		if let obj = objects.first(where: { elem in elem.journeyRef == deleteRef}) {
			context.delete(obj)
		}

		do {
			try context.save()
			print("📗 > delete SavedJourney")
		} catch {
			let nserror = error as NSError
			print("🔴 > delete SavedJourneys: ", nserror.localizedDescription)
		}
	}
}
