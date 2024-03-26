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
	@NSManaged public var depArrStops: Data
	@NSManaged public var user: CDUser?
	@NSManaged public var isActive: Bool
	@NSManaged public var legs: Set<CDLeg>
	@NSManaged public var time: Data
	@NSManaged public var sunEvents: Set<CDSunEvent>
	@NSManaged public var updatedAt: Double
	@NSManaged public var journeySettings: Data?
}

extension CDJourney {
	convenience init(
		viewData : JourneyViewData,
		user : CDUser,
		stops : DepartureArrivalPairStop,
		id : Int64,
		using managedObjectContext: NSManagedObjectContext) {
			self.init(entity: CDJourney.entity(), insertInto: managedObjectContext)
			self.id = id
			self.isActive = false
			self.journeyRef = viewData.refreshToken
			self.updatedAt = Date.now.timeIntervalSince1970
			if let time = try?  JSONEncoder().encode(viewData.time.iso) {
				self.time = time
			}
			if let sett = try?  JSONEncoder().encode(viewData.settings) {
				self.journeySettings = sett
			}
			if let stops = try? JSONEncoder().encode(stops) {
				self.depArrStops = stops
			}
			viewData.legs.forEach {
				let _ = CDLeg(context: managedObjectContext,leg: $0,for: self)
			}
			viewData.sunEvents.forEach {
				let _ = CDSunEvent(context: managedObjectContext,sun: $0,for: self)
			}
			user.addToChewJourneys(self)
		}
}
