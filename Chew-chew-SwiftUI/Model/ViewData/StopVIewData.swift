//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct StopViewData : Equatable,Identifiable {
	let id = UUID()
	let locationCoordinates : CLLocationCoordinate2D
	let name : String
	let departurePlatform : Prognosed<String>
	let arrivalPlatform : Prognosed<String>
	let time : TimeContainer
	let stopOverType : StopOverType
	
	func cancellationType() -> StopOverCancellationType {
		switch self.stopOverType {
		case .stopover:
			if time.arrivalStatus == .cancelled && time.departureStatus == .cancelled {
				return .fullyCancelled
			}
			if time.arrivalStatus == .cancelled {
				return .entryOnly
			}
			if time.departureStatus == .cancelled {
				return .exitOnly
			}
			return .notCancelled
		case .origin:
			if time.departureStatus == .cancelled {
				return .fullyCancelled
			}
			return .notCancelled
		case .destination:
			if time.arrivalStatus == .cancelled {
				return .fullyCancelled
			}
			return .notCancelled
		default:
			return .notCancelled
		}
	}
}


extension StopViewData {
	init(
		name : String,
		time : TimeContainer,
		stop : StopWithTimeDTO,
		type: StopOverType
	) {
		self.time = time
		self.name = name
		self.departurePlatform  = Prognosed(actual: stop.departurePlatform, planned: stop.plannedDeparturePlatform)
		self.arrivalPlatform  = Prognosed(actual: stop.arrivalPlatform, planned: stop.plannedArrivalPlatform)
		self.stopOverType = type
		self.locationCoordinates = CLLocationCoordinate2D(
			latitude: stop.stop?.location?.latitude ?? stop.stop?.latitude ?? -1,
			longitude: stop.stop?.location?.longitude ?? stop.stop?.longitude ?? -1
		)
	}
	
	init(
		name : String,
		time : TimeContainer,
		type: StopOverType,
		coordinates : CLLocationCoordinate2D
	) {
		self.time = time
		self.name = name
		self.departurePlatform  = Prognosed(actual: nil, planned: nil)
		self.arrivalPlatform  = Prognosed(actual: nil, planned: nil)
		self.stopOverType = type
		self.locationCoordinates = coordinates
	}
}
