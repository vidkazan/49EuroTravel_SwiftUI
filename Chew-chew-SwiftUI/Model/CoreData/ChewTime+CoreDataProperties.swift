//
//  ChewUser+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

extension ChewTime {
	@NSManaged public var actualArrival : String?
	@NSManaged public var actualDeparture : String?
	@NSManaged public var plannedArrival : String?
	@NSManaged public var plannedDeparture : String?
	@NSManaged public var cancelled : Bool
	
	@NSManaged public var chewJourney : ChewJourney?
	@NSManaged public var leg: ChewLeg?
}

extension ChewTime {
	static func updateWith(
		container : TimeContainer,
		isCancelled : Bool,
		using managedObjectContext: NSManagedObjectContext,
		chewTime : ChewTime?
	) {
		guard let chewTime = chewTime else {return}
		chewTime.actualArrival = container.iso.arrival.actual
		chewTime.plannedArrival = container.iso.arrival.planned
		chewTime.actualDeparture = container.iso.departure.actual
		chewTime.plannedDeparture = container.iso.departure.planned
		chewTime.cancelled = isCancelled
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > save ChewTime: fialed to update ChewTime", nserror.localizedDescription)
		}
	}

	static func createWith(
		container : TimeContainer,
		using managedObjectContext: NSManagedObjectContext,
		for chewJourney : ChewJourney,
		isCancelled : Bool
	) {
		let _ = ChewTime(context: managedObjectContext,container: container,cancelled: isCancelled,for: chewJourney)
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > save ChewTime: fialed to save new ", nserror.localizedDescription)
		}
	}

	static func basicFetchRequest(context : NSManagedObjectContext) -> TimeContainer {
		if let res = fetch(context: context) {
			return TimeContainer(chewTime: res)
		}
		ChewUser.createWith(date: .now, using: context)
		return TimeContainer(chewTime: fetch(context: context))
	}

	static private func fetch(context : NSManagedObjectContext) -> ChewTime? {
		do {
			let res = try context.fetch(.init(entityName: "ChewTime")).first as? ChewTime
			if let res = res {
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
