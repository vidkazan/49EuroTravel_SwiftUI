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
}

extension ChewJourney {
	static func basicFetchRequest(context : NSManagedObjectContext) -> [ChewJourney]? {
		return fetch(context: context)
	}
	
	static private func fetch(context : NSManagedObjectContext) -> [ChewJourney]? {
		do {
			let res = try context.fetch(.init(entityName: "ChewJourney")) as? [ChewJourney]
			if let res = res {
				print("📗 > basicFetchRequest ChewJourney")
				return res
			}
			print("📙 > basicFetchRequest \(Self.self): context.fetch: result is empty")
			return nil
		} catch {
			print("📕 > basicFetchRequest \(Self.self): context.fetch error")
			return nil
		}
	}
	
	static func createWith(
		viewData : JourneyViewData,
		user : ChewUser?,
		depStop : Stop?,
		arrStop : Stop?,
		ref : String,
		using managedObjectContext: NSManagedObjectContext,
		in object : [ChewJourney]?
	) {
		guard object?.contains(where: { elem in elem.journeyRef == ref}) != true else {
			print("📕 > create ChewJourney: return by duplication")
			return
		}
		guard let user = user else {
			print("📕 > create ChewJourney: user is nil")
			return
		}
		let journey = ChewJourney(context: managedObjectContext)
		journey.isActive = false
		journey.journeyRef = ref
		journey.user = user
		
		let _ = ChewTime(context: managedObjectContext, container: viewData.timeContainer, cancelled: !viewData.isReachable,for: journey)
		
		for leg in viewData.legs {
			let _ = ChewLeg(context: managedObjectContext, leg: leg,for: journey)
		}
		
		for sun in viewData.sunEvents {
			let _ = ChewSunEvent(
				context: managedObjectContext,
				sun: sun,
				for: journey
			)
		}

		if let depStop = depStop ,let arrStop = arrStop {
			let departure = Location(context: managedObjectContext,stop: depStop)
			let arrival = Location(context: managedObjectContext,stop: arrStop)

			departure.chewJourneyDep = journey
			arrival.chewJourneyArr = journey
		}
		do {
			try managedObjectContext.save()
			print("📙 > create ChewJourney: created new ChewJourney")
		} catch {
			let nserror = error as NSError
			print("📕 > create ChewJourney: ", nserror.localizedDescription)
		}
	}
	
	static func delete(deleteRef : String,in objects : [ChewJourney]?, context : NSManagedObjectContext) {
		guard let objects = objects else {
			print("📕 > delete ChewJourneys: object is nil")
			return
		}
		if let obj = objects.first(where: { elem in elem.journeyRef == deleteRef}) {
			if let depStop = obj.departureStop { context.delete(depStop) }
			if let arrStop = obj.arrivalStop { context.delete(arrStop) }
			if let time = obj.time { context.delete(time) }
			if let legs = obj.legs {
			for leg in legs {
					context.delete(leg)
					if let time = leg.time { context.delete(time) }
				}
			}
			context.delete(obj)
		}

		do {
			try context.save()
			print("📗 > delete ChewJourney")
		} catch {
			let nserror = error as NSError
			print("📕 > delete ChewJourneys: ", nserror.localizedDescription)
		}
	}
}
