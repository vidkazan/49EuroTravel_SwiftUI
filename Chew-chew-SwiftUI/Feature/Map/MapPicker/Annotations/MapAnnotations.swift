//
//  Annotations.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 13.02.24.
//

import Foundation
import CoreLocation
import MapKit

class LocationAnnotation : MKPointAnnotation {
	
}

class StopAnnotation: NSObject, Identifiable {
	enum AnnotationType {
		case bus
		case train
		case tram
		case ubahn
		case ferry
		case taxi
		case sbahn
	}
	let stopId : String
	let name: String
	let location: CLLocationCoordinate2D
	let type : AnnotationType
	
	init(stopId: String, name: String, location: CLLocationCoordinate2D, type: AnnotationType) {
		self.stopId = stopId
		self.name = name
		self.location = location
		self.type = type
	}
}

extension StopAnnotation : MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		location
	}
	var title: String? {
		name
	}
}
