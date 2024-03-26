//
//  ViewData.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 09.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

struct StopViewData : Identifiable, Hashable {
	let id : String?
	let locationCoordinates : Coordinate
	let name : String
	let platforms : DepartureArrivalPair<Prognosed<String>>
	let time : TimeContainer
	let stopOverType : StopOverType
	
	func cancellationType() -> StopOverCancellationType {
		switch self.stopOverType {
		case .stopover:
			if time.arrivalStatus == .cancelled 
				&&
				time.departureStatus == .cancelled {
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
	func stop() -> Stop? {
		if let id = id {
			return Stop(
				coordinates: self.locationCoordinates,
				type: .stop,
				stopDTO: StopDTO(
					type: nil,
					id: id,
					name: self.name,
					address: nil,
					location: nil,
					latitude: self.locationCoordinates.latitude,
					longitude: self.locationCoordinates.longitude,
					poi: nil,
					products: nil,
					distance: nil,
					station: nil
				)
			)
		}
		return nil
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
		self.stopOverType = type
		self.locationCoordinates = Coordinate(
			latitude: stop.stop?.location?.latitude ?? stop.stop?.latitude ?? -1,
			longitude: stop.stop?.location?.longitude ?? stop.stop?.longitude ?? -1
		)
		self.id = stop.stop?.id
		self.platforms = .init(
			departure: Prognosed(actual: stop.departurePlatform, planned: stop.plannedDeparturePlatform),
			arrival: Prognosed(actual: stop.arrivalPlatform, planned: stop.plannedArrivalPlatform)
		)
	}
	
	init(
		stopId : String?,
		name : String,
		time : TimeContainer,
		type: StopOverType,
		coordinates : Coordinate
	) {
		self.time = time
		self.name = name
		self.stopOverType = type
		self.locationCoordinates = coordinates
		self.id = stopId
		self.platforms = .init(
			departure: .init(),
			arrival: .init()
		)
	}
}
