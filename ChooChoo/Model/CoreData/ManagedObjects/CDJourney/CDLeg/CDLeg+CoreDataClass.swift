//
//  CDLeg+CoreDataClass.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.12.23.
//
//

import Foundation
import CoreData

@objc(CDLeg)
public class CDLeg: NSManagedObject {

}

extension CDLeg {
	convenience init(context : NSManagedObjectContext,leg : LegViewData,for journey : CDJourney){
		self.init(entity: CDLeg.entity(), insertInto: context)
		self.tripId = leg.tripId
		self.isReachable = leg.isReachable
		self.legBottomPosition = leg.legBottomPosition
		self.legTopPosition = leg.legTopPosition
		self.lineName = leg.lineViewData.name
		self.lineShortName = leg.lineViewData.shortName
		self.lineType = leg.lineViewData.type.rawValue
		if let legDTO = try? JSONEncoder().encode(leg.legDTO), let string = String(data: legDTO, encoding: .utf8) {
			self.legDTO = string
		}
				
		self.journey = journey

		let _ = CDLegType(insertIntoManagedObjectContext: context, type: leg.legType, for: self)
		
		if let time = leg.time.encode() {
			self.time = time
		}
//		let _ = CDTime(context: context, container: leg.time, cancelled: !leg.isReachable,for: self)
		
		for stop in leg.legStopsViewData {
			let _ = CDStop(insertInto: context, with: stop, to: self)
		}
	}
}

extension CDLeg {
	func legViewData() -> LegViewData {
		var stopsViewData = [StopViewData]()
		
		stopsViewData = stops.map { $0.stopViewData() }
		
		let time = TimeContainer(isoEncoded: self.time) ?? .init()
//		let time = TimeContainer(chewTime: self.time)
		let segments = segments(from : stopsViewData)
		var legDTOobj : LegDTO? = nil
		if let legDTOdata = legDTO?.data(using: .utf8) {
			legDTOobj = try? JSONDecoder().decode(LegDTO.self, from: legDTOdata)
		}
		return LegViewData(
			isReachable: self.isReachable,
			legType: self.chewLegType.legType ?? .line,
			tripId: self.tripId,
			direction: self.stops.last?.name ?? "direction",
			legTopPosition: self.legTopPosition,
			legBottomPosition: self.legBottomPosition,
			remarks: [],
			legStopsViewData: stopsViewData,
			footDistance: -1,
			lineViewData: LineViewData(
				type: LineType(rawValue: self.lineType) ?? .taxi,
				name: self.lineName,
				shortName: self.lineShortName
			),
			progressSegments: segments,
			time: time,
			polyline: nil,
			legDTO : legDTOobj
		)
	}
}
