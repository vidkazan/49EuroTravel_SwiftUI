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
	convenience init(context : NSManagedObjectContext,stop : Stop, chewJourneyDep : ChewJourney){
		self.init(context: context)
		
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
		self.chewJourneyDep = chewJourneyDep
	}
	
	convenience init(context : NSManagedObjectContext,stop : Stop, chewJourneyArr : ChewJourney){
		self.init(context: context)
		
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
		self.chewJourneyArr = chewJourneyArr
	}
	
	convenience init(context : NSManagedObjectContext,stop : Stop){
		self.init(context: context)
		
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
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
