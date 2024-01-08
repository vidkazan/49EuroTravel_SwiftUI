//
//  ChewJourney+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension ChewJourney {
    @NSManaged public var journeyRef: String
    @NSManaged public var arrivalStop: Location?
    @NSManaged public var departureStop: Location?
	@NSManaged public var user: ChewUser?
	@NSManaged public var isActive: Bool
	@NSManaged public var legs: [ChewLeg]?
	@NSManaged public var time: ChewTime?
	@NSManaged public var sunEvents: [ChewSunEvent]?
	@NSManaged public var updatedAt: Double
}

extension ChewJourney {
	static func createWith(
		viewData : JourneyViewData,
		user : ChewUser,
		depStop : Stop?,
		arrStop : Stop?,
		ref : String,
		using managedObjectContext: NSManagedObjectContext,
		in object : [ChewJourney]
	) {
		managedObjectContext.perform {
			print("> ⚡️ add Journey ",Thread.current)
			let journey = ChewJourney(context: managedObjectContext)
			journey.isActive = false
			journey.journeyRef = ref
			journey.updatedAt = viewData.updatedAt
			journey.user = user
			
			let _ = ChewTime(
				context: managedObjectContext,
				container: viewData.timeContainer,
				cancelled: !viewData.isReachable,
				for: journey
			)
			
			for leg in viewData.legs {
				let _ = ChewLeg(
					context: managedObjectContext,
					leg: leg,
					for: journey
				)
			}

			for sun in viewData.sunEvents {
				let _ = ChewSunEvent(
					context: managedObjectContext,
					sun: sun,
					for: journey
				)
			}

			if let depStop = depStop ,let arrStop = arrStop {
				let dep = Location(context: managedObjectContext,stop: depStop)
				let arr = Location(context: managedObjectContext,stop: arrStop)
				journey.departureStop = dep
				journey.arrivalStop = arr
			}
			do {
				try managedObjectContext.save()
				print("📙 > create \(Self.self): created")
			} catch {
				let nserror = error as NSError
				print("📕 > create \(Self.self): ", nserror.localizedDescription)
			}
		}
	}
}

// delete
extension ChewJourney {
	static func delete(object: ChewJourney?,in context : NSManagedObjectContext) {
		guard let object = object else {
			print("📕 > delete \(Self.self): object is nil")
			return
		}

		context.delete(object)

		do {
			try context.save()
			print("📗 > delete \(Self.self)")
		} catch {
			let nserror = error as NSError
			print("📕 > delete \(Self.self): ", nserror.localizedDescription)
		}
	}
	
//	static func deleteIfFound(deleteRef : String,in objects : [ChewJourney]?, context : NSManagedObjectContext) {
//		guard let objects = Self.basicFetchRequest(context: context) else {
//			print("📕 > delete \(Self.self): list is nil")
//			return
//		}
//		if let obj = objects.first(where: {elem in elem.journeyRef == deleteRef}) {
//			ChewJourney.delete(object: obj, in: context)
//		} else {
//			print("📕 > delete \(Self.self): not found")
//		}
//	}
}
