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
			let departure = Location(context: managedObjectContext,stop: depStop)
			let arrival = Location(context: managedObjectContext,stop: arrStop)
			
			departure.chewJourneyDep = journey
			arrival.chewJourneyArr = journey
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


extension ChewJourney {
	static func updateIfFound(
		of updateRef : String,
		in objects : [ChewJourney]?,
		with viewData : JourneyViewData,
		context : NSManagedObjectContext?,
		chewUser : ChewUser?,
		depStop : Stop?,
		arrStop : Stop?
	) {
		guard let context = context,
			  let objects = Self.basicFetchRequest(context: context) else {
			print("📕 > update \(Self.self): list is nil")
			return
		}
		if let obj = objects.first(where: { elem in
			print(">>> ",elem.journeyRef)
			return elem.journeyRef == updateRef
		}) {
			ChewJourney.delete(object: obj, in: context)
			ChewJourney.createWith(
				viewData: viewData,
				user: chewUser,
				depStop: depStop,
				arrStop: arrStop,
				ref: updateRef,
				using: context,
				in: objects
			)
//			ChewJourney.updateWith(of: obj, with: viewData, using: context)
		} else {
			print(">>>> ",updateRef)
			print("📕 > update \(Self.self): not found")
		}
	}
	
	static func updateWith(
		of obj : ChewJourney?,
		with viewData : JourneyViewData,
		using managedObjectContext: NSManagedObjectContext
	) {
		guard let obj = obj else { return }

		obj.isActive = false
		obj.updatedAt = viewData.updatedAt
		
		ChewTime.updateWith(
			container: viewData.timeContainer,
			isCancelled: !viewData.isReachable,
			using: managedObjectContext,
			chewTime: obj.time
		)
		
		if let legs = obj.legs {
			for leg in legs {
				ChewLeg.delete(object: leg, in: managedObjectContext)
			}
		}
		
		for leg in viewData.legs {
			let _ = ChewLeg(
				context: managedObjectContext,
				leg: leg,
				for: obj
			)
		}
		
		if let suns = obj.sunEvents {
			for sun in suns {
				ChewSunEvent.delete(object: sun, in: managedObjectContext)
			}
		}
		
		for sun in viewData.sunEvents {
			let _ = ChewSunEvent(
				context: managedObjectContext,
				sun: sun,
				for: obj
			)
		}
		
//		if let depStop = depStop ,let arrStop = arrStop {
//			let departure = Location(context: managedObjectContext,stop: depStop)
//			let arrival = Location(context: managedObjectContext,stop: arrStop)
//
//			departure.chewJourneyDep = journey
//			arrival.chewJourneyArr = journey
//		}


		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > update \(Self.self): fialed to update", nserror.localizedDescription)
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
		
		if let depStop = object.departureStop { Location.delete(object: depStop, in: context)}
		if let arrStop = object.arrivalStop { Location.delete(object: arrStop, in: context) }
		if let time = object.time { ChewTime.delete(time: time, in: context) }
		if let legs = object.legs {
			for leg in legs {
				ChewLeg.delete(object: leg, in: context)
			}
		}
		
		if let suns = object.sunEvents {
			for sun in suns {
				ChewSunEvent.delete(object: sun, in: context)
			}
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
	
	static func deleteIfFound(deleteRef : String,in objects : [ChewJourney]?, context : NSManagedObjectContext) {
		guard let objects = Self.basicFetchRequest(context: context) else {
			print("📕 > delete \(Self.self): list is nil")
			return
		}
		if let obj = objects.first(where: {elem in elem.journeyRef == deleteRef}) {
			ChewJourney.delete(object: obj, in: context)
		} else {
			print("📕 > delete \(Self.self): not found")
		}
	}
}




// fetch
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
}
