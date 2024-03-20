//
//  CDUser+CoreDataProperties.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

extension CDTime {
	@NSManaged public var actualArrival : String?
	@NSManaged public var actualDeparture : String?
	@NSManaged public var plannedArrival : String?
	@NSManaged public var plannedDeparture : String?
	@NSManaged public var cancelled : Bool
	
	@NSManaged public var chewJourney : CDJourney?
	@NSManaged public var leg: ChewLeg?
	@NSManaged public var stop: ChewStop?
}
