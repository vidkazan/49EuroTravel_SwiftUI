//
//  CDJourney+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData


extension CDJourney {
	@NSManaged public var id: Int64
    @NSManaged public var journeyRef: String
    @NSManaged public var arrivalStop: CDLocation
    @NSManaged public var departureStop: CDLocation
	@NSManaged public var user: CDUser?
	@NSManaged public var isActive: Bool
	@NSManaged public var legs: Set<CDLeg>
	@NSManaged public var time: CDTime
	@NSManaged public var sunEvents: Set<CDSunEvent>
	@NSManaged public var updatedAt: Double
}

extension CDJourney {
	convenience init(
		viewData : JourneyViewData,
		user : CDUser,
		depStop : Stop,
		arrStop : Stop,
		id : Int64,
		using managedObjectContext: NSManagedObjectContext) {
			self.init(entity: CDJourney.entity(), insertInto: managedObjectContext)
			self.id = id
			self.isActive = false
			self.journeyRef = viewData.refreshToken
			self.updatedAt = Date.now.timeIntervalSince1970
			let _ = CDTime(
				context: managedObjectContext,
				container: viewData.time,
				cancelled: !viewData.isReachable,
				for: self
			)
			viewData.legs.forEach {
				let _ = CDLeg(context: managedObjectContext,leg: $0,for: self)
			}
			viewData.sunEvents.forEach {
				let _ = CDSunEvent(context: managedObjectContext,sun: $0,for: self)
			}
			let _ = CDLocation(
				context: managedObjectContext,
				stop: depStop,
				parent: .followedJourneyDepStop(self)
			)
			let _ = CDLocation(
				context: managedObjectContext,
				stop: arrStop,
				parent: .followedJourneyArrStop(self)
			)
			user.addToChewJourneys(self)
		}
}
