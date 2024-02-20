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
	enum ParentEntity {
		case recentLocation(_ user : ChewUser)
		case followedJourneyDepStop(_ followedJourney : ChewJourney)
		case followedJourneyArrStop(_ followedJourney : ChewJourney)
		case recentSearchDepStop(_ recentSearch : ChewRecentSearch)
		case recentSearchArrStop(_ recentSearch : ChewRecentSearch)
	}

	convenience init(context : NSManagedObjectContext,stop : Stop, parent : ParentEntity, products : Products? = nil){
		
		self.init(entity: Location.entity(), insertInto: context)

		switch parent {
		case .recentLocation(let user):
			user.addToRecentLocations(self)
		case .followedJourneyDepStop(let journeyDep):
			self.chewJourneyDep = journeyDep
		case .followedJourneyArrStop(let journeyArr):
			self.chewJourneyArr = journeyArr
		case .recentSearchDepStop(let recentSearchDepStop):
			self.chewRecentSearchDepStop = recentSearchDepStop
		case .recentSearchArrStop(let recentSearchArrStop):
			self.chewRecentSearchArrStop = recentSearchArrStop
		}
		
		
		self.api_id = stop.stopDTO?.id
		self.address = stop.stopDTO?.address
		self.latitude = stop.coordinates.latitude
		self.longitude = stop.coordinates.longitude
		self.name = stop.name
		self.type = stop.type.rawValue
		self.transportType = products?.lineType?.rawValue
	}
}
