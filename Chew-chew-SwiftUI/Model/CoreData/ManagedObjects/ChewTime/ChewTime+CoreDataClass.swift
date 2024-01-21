//
//  ChewTime+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

@objc(ChewTime)
public class ChewTime: NSManagedObject {

}

extension ChewTime {
	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool, for journey : ChewJourney){
		self.init(context: context)
		
		self.chewJourney = journey
		self.cancelled =  cancelled
		self.actualArrival = container.iso.arrival.actual
		self.plannedArrival = container.iso.arrival.planned
		self.plannedDeparture = container.iso.departure.planned
		self.actualDeparture = container.iso.departure.actual
	}
	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool, for leg : ChewLeg){
		self.init(context: context)
		
		self.leg = leg
		
		self.cancelled =  cancelled
		self.actualArrival = container.iso.arrival.actual
		self.plannedArrival = container.iso.arrival.planned
		self.plannedDeparture = container.iso.departure.planned
		self.actualDeparture = container.iso.departure.actual
	}
	
	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool, for stop : ChewStop){
		self.init(context: context)
		
		self.stop = stop
		
		self.cancelled =  cancelled
		self.actualArrival = container.iso.arrival.actual
		self.plannedArrival = container.iso.arrival.planned
		self.plannedDeparture = container.iso.departure.planned
		self.actualDeparture = container.iso.departure.actual
	}
}
