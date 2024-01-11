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
    @NSManaged public var arrivalStop: Location
    @NSManaged public var departureStop: Location
	@NSManaged public var user: ChewUser?
	@NSManaged public var isActive: Bool
	@NSManaged public var legs: [ChewLeg]
	@NSManaged public var time: ChewTime
	@NSManaged public var sunEvents: [ChewSunEvent]
	@NSManaged public var updatedAt: Double
}

extension ChewJourney {
	convenience init(
		viewData : JourneyViewData,
		user : ChewUser,
		depStop : Stop,
		arrStop : Stop,
		ref : String,
		using managedObjectContext: NSManagedObjectContext) {
			self.init(context: managedObjectContext)
				print("> ⚡️ create \(ChewJourney.self) thread: ",Thread.current, "context:",managedObjectContext)
				self.isActive = false
				self.journeyRef = ref
				self.updatedAt = viewData.updatedAt
				self.user = user
				let _ = ChewTime(
					context: managedObjectContext,
					container: viewData.timeContainer,
					cancelled: !viewData.isReachable,
					for: self
				)
				viewData.legs.forEach {
					let leg = ChewLeg(context: managedObjectContext,leg: $0,for: self)
				}
				viewData.sunEvents.forEach {
					let _ = ChewSunEvent(context: managedObjectContext,sun: $0,for: self)
				}
				let _ = Location(context: managedObjectContext,stop: depStop,journeyDep: self)
				let _ = Location(context: managedObjectContext,stop: arrStop,journeyArr: self)
			}
}
