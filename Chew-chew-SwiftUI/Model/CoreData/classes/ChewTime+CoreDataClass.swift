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
	convenience init(context : NSManagedObjectContext,container : TimeContainer,cancelled : Bool){
		self.init(context: context)
		
		self.cancelled =  cancelled
		self.actualArrival = container.iso.arrival.actual
		self.plannedArrival = container.iso.arrival.planned
		self.plannedDeparture = container.iso.departure.planned
		self.actualDeparture = container.iso.departure.actual
	}
}
