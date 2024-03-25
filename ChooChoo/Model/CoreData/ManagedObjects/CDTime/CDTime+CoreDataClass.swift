//
//  CDTime+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

//@objc(CDTime)
//public class CDTime: NSManagedObject {
//
//}
//
//extension CDTime {
//	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool, for journey : CDJourney){
//		self.init(entity: CDTime.entity(), insertInto: context)
//		
//		self.chewJourney = journey
//		self.cancelled =  cancelled
//		self.actualArrival = container.iso.arrival.actual
//		self.plannedArrival = container.iso.arrival.planned
//		self.plannedDeparture = container.iso.departure.planned
//		self.actualDeparture = container.iso.departure.actual
//	}
//	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool, for leg : CDLeg){
//		self.init(entity: CDTime.entity(), insertInto: context)
//		
//		self.leg = leg
//		
//		self.cancelled =  cancelled
//		self.actualArrival = container.iso.arrival.actual
//		self.plannedArrival = container.iso.arrival.planned
//		self.plannedDeparture = container.iso.departure.planned
//		self.actualDeparture = container.iso.departure.actual
//	}
//	
//	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool, for stop : CDStop){
//		self.init(entity: CDTime.entity(), insertInto: context)
//		
//		self.stop = stop
//		
//		self.cancelled =  cancelled
//		self.actualArrival = container.iso.arrival.actual
//		self.plannedArrival = container.iso.arrival.planned
//		self.plannedDeparture = container.iso.departure.planned
//		self.actualDeparture = container.iso.departure.actual
//	}
//}
