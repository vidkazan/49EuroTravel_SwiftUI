//
//  ChewStop+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(ChewStop)
public class ChewStop: NSManagedObject {

}

extension ChewStop {
	convenience init(insertInto context: NSManagedObjectContext,with stopData : StopViewData, to leg :  ChewLeg) {
		self.init(context: context)
		
		self.lat = stopData.locationCoordinates.latitude
		self.long = stopData.locationCoordinates.longitude
		self.name = stopData.name
		self.stopOverType = stopData.stopOverType.rawValue
		self.isCancelled = stopData.isCancelled ?? false
		
		self.leg = leg
		let _ = ChewTime(context: context, container: stopData.timeContainer, cancelled: stopData.isCancelled ?? false, for: self)
		
		let _ = ChewPrognosedPlatform(insertInto: context, with: stopData.departurePlatform, to: self, type: .departure)
		let _ = ChewPrognosedPlatform(insertInto: context, with: stopData.arrivalPlatform, to: self, type: .arrival)
		
		
		do {
			try context.save()
		} catch {
			let nserror = error as NSError
			print("📕 > save \(Self.self): failed to save new ", nserror.localizedDescription)
		}
	}
}

extension ChewStop {
	static func updateWith(
		of obj : ChewStop?,
		with stopData : StopViewData,
		using managedObjectContext: NSManagedObjectContext
	) {
		guard let obj = obj else { return }
		
		obj.lat = stopData.locationCoordinates.latitude
		obj.long = stopData.locationCoordinates.longitude
		obj.name = stopData.name
		obj.stopOverType = stopData.stopOverType.rawValue
		obj.isCancelled = stopData.isCancelled ?? false
		
		ChewTime.updateWith(
			container: stopData.timeContainer,
			isCancelled: stopData.isCancelled ?? false,
			using: managedObjectContext,
			chewTime: obj.time
		)
		
		ChewPrognosedPlatform.updateWith(
			of: obj.depPlatform,
			with: stopData.departurePlatform,
			using: managedObjectContext
		)
		ChewPrognosedPlatform.updateWith(
			of: obj.arrPlatform,
			with: stopData.arrivalPlatform,
			using: managedObjectContext
		)
		
		do {
			try managedObjectContext.save()
		} catch {
			let nserror = error as NSError
			print("📕 > update \(Self.self): fialed to update", nserror.localizedDescription)
		}
	}
}

extension ChewStop {
	func stopViewData() -> StopViewData {
		let time = TimeContainer(chewTime: self.time)
		return StopViewData(
			locationCoordinates: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long),
			name: self.name,
			departurePlatform: Prognosed<String?>(actual: self.depPlatform?.actual, planned: self.depPlatform?.planned),
			arrivalPlatform: Prognosed<String?>(actual: self.arrPlatform?.actual, planned: self.arrPlatform?.planned),
			timeContainer: time,
			stopOverType: StopOverType(rawValue: self.stopOverType) ?? .stopover,
			isCancelled: self.isCancelled
		)
	}
}
