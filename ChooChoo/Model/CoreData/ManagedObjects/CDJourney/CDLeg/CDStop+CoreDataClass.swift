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
//		let _ = CDTime(
//			context: context,
//			container: stopData.time,
//			cancelled: stopData.cancellationType() == .fullyCancelled,
//			for: self
//		)
		
		let _ = CDPrognosedPlatform(insertInto: context, with: stopData.platforms.departure, to: self, type: .departure)
		let _ = CDPrognosedPlatform(insertInto: context, with: stopData.platforms.arrival, to: self, type: .arrival)
	}
}

#warning("finish here")
extension CDStop {
	func stopViewData() -> StopViewData {
		var time = TimeContainer()
		if let isoTime =  try? JSONDecoder().decode(TimeContainer.ISOTimeContainer.self, from: self.time) {
			time = TimeContainer(iso: isoTime)
		} 
//		else {
//			return nil
//		}
		return StopViewData(
			id: self.stopId,
			locationCoordinates: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long),
			name: self.name,
			platforms: .init(
				departure: Prognosed<String>(actual: self.depPlatform?.actual, planned: self.depPlatform?.planned),
				arrival: Prognosed<String>(actual: self.arrPlatform?.actual, planned: self.arrPlatform?.planned)
			),
//			departurePlatform: Prognosed<String>(actual: self.depPlatform?.actual, planned: self.depPlatform?.planned),
//			arrivalPlatform: Prognosed<String>(actual: self.arrPlatform?.actual, planned: self.arrPlatform?.planned),
			time: time,
			stopOverType: StopOverType(rawValue: self.stopOverType) ?? .stopover
		)
	}
}
