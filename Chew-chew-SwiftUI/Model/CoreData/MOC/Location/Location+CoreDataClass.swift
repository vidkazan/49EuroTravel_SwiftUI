//
//  Location+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 21.11.23.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
}

extension Location {
	convenience init(context : NSManagedObjectContext,stop : Stop, journeyDep : ChewJourney){
		self.init(context: context)
		
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
//		context.performAndWait {
			self.chewJourneyDep = journeyDep
//		}
	}
	
	convenience init(context : NSManagedObjectContext,stop : Stop, journeyArr : ChewJourney){
		self.init(context: context)
		
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
//		context.performAndWait {
			self.chewJourneyArr = journeyArr
//		}
	}
	convenience init(context : NSManagedObjectContext,stop : Stop, user : ChewUser){
		self.init(context: context)
		self.user = user
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
	}
}
