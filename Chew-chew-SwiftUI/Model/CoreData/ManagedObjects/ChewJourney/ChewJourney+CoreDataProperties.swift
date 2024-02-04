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
	@NSManaged public var id: Int64
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
		id : Int64,
		using managedObjectContext: NSManagedObjectContext) {
			self.init(context: managedObjectContext)
//				print("> ⚡️ create \(ChewJourney.self) thread: ",Thread.current, "context:",managedObjectContext)
			self.id = id
			self.isActive = false
			self.journeyRef = viewData.refreshToken
			self.updatedAt = Date.now.timeIntervalSince1970
			self.user = user
			let _ = ChewTime(
				context: managedObjectContext,
				container: viewData.time,
				cancelled: !viewData.isReachable,
				for: self
			)
			viewData.legs.forEach {
				let _ = ChewLeg(context: managedObjectContext,leg: $0,for: self)
			}
			viewData.sunEvents.forEach {
				let _ = ChewSunEvent(context: managedObjectContext,sun: $0,for: self)
			}
			let _ = Location(context: managedObjectContext,stop: depStop,parent: .followedJourneyDepStop(self))
			let _ = Location(context: managedObjectContext,stop: arrStop,parent: .followedJourneyArrStop(self))
		}
}
