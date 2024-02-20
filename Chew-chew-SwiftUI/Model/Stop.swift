//
//  Location.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.10.23.
//

import Foundation
import CoreLocation

struct Stop : Equatable,Identifiable, Hashable {
	let id : String
	var coordinates: CLLocationCoordinate2D
	var type: LocationType
	var stopDTO : StopDTO?
	var name : String

	init(){
		self.id  = ""
		self.coordinates = .init()
		self.stopDTO = nil
		self.name = "Default stop name"
		self.type = .stop
	}
	
	init(coordinates: CLLocationCoordinate2D, type: LocationType, stopDTO: StopDTO?) {
		self.coordinates = coordinates
		self.type = type
		self.stopDTO = stopDTO
		self.name = stopDTO?.name ?? stopDTO?.address ?? "\(String(coordinates.latitude)) , \(String(coordinates.longitude))"
		self.id = stopDTO?.id ?? self.name
	}
}

extension Stop {
	func stopAnnotation() -> StopAnnotation? {
		if let products = stopDTO?.products {
			let type : StopAnnotation.AnnotationType? = {
				if products.national == true ||
					products.nationalExpress == true {
					return .national
				}
				if products.regional == true ||
					products.regionalExpress == true {
					return .regional
				}
				if products.suburban == true {
					return .sbahn
				}
				if products.subway == true {
					return .ubahn
				}
				if products.tram == true {
					return .tram
				}
				if products.bus == true {
					return .bus
				}
				if products.ferry == true {
					return .ferry
				}
				if products.taxi == true {
					return .taxi
				}
				return nil
			}()
			
			if let type = type {
				return StopAnnotation(
					stopId: id,
					name: name,
					location: coordinates,
					type: type
				)
			}
		}
		return nil
	}
}
