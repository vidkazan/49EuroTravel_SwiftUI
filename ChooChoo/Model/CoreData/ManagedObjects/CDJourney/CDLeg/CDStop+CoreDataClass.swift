//
//  CDStop+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(CDStop)
public class CDStop: NSManagedObject {

}

extension CDStop {
	convenience init(insertInto context: NSManagedObjectContext,with stopData : StopViewData, to leg :  CDLeg) {
		self.init(entity: CDStop.entity(), insertInto: context)
		self.stopId = stopData.id
		self.lat = stopData.locationCoordinates.latitude
		self.long = stopData.locationCoordinates.longitude
		self.name = stopData.name
		self.stopOverType = stopData.stopOverType.rawValue
		self.isCancelled = stopData.cancellationType() == .fullyCancelled
		self.leg = leg
		if let time = stopData.time.encode() {
			self.time = time
		}
		self.platforms = stopData.platforms.encode()
	}
}

extension CDStop {
	func stopViewData() -> StopViewData {
		var time = TimeContainer()
		if let isoTime =  try? JSONDecoder().decode(TimeContainer.ISOTimeContainer.self, from: self.time) {
			time = TimeContainer(iso: isoTime)
		}
		
		var platforms : DepartureArrivalPair<Prognosed<String>> = .init(departure: .init(), arrival: .init())
		if let platformsData = self.platforms,
		   let platformsDecoded = DepartureArrivalPair<Prognosed<String>>.decode(data: platformsData){
			platforms = platformsDecoded
		}
//		else {
//			return nil
//		}
		return StopViewData(
			id: self.stopId,
			locationCoordinates: Coordinate(latitude: self.lat, longitude: self.long),
			name: self.name,
			platforms: platforms,
			time: time,
			stopOverType: StopOverType(rawValue: self.stopOverType) ?? .stopover
		)
	}
}
