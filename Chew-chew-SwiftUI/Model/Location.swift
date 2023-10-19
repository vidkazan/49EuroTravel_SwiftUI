//
//  Location.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation
import CoreLocation

protocol ChewLocation {
	var coordinates : CLLocationCoordinate2D { get }
	var type : LocationType { get }
}

struct Stop : ChewLocation,Equatable,Identifiable {
	let id = UUID()
	var coordinates: CLLocationCoordinate2D
	var type: LocationType
	var stopDTO : StopDTO?
	var name : String
	
	init(coordinates: CLLocationCoordinate2D, type: LocationType, stopDTO: StopDTO?) {
		self.coordinates = coordinates
		self.type = type
		self.stopDTO = stopDTO
		self.name = stopDTO?.name ??
		stopDTO?.address ??
		"\(String(coordinates.latitude).prefix(5)) , \(String(coordinates.longitude).prefix(5))"
	}
}
