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
	enum AnnotationType : CaseIterable {
		case bus
		case national
		case regional
		case tram
		case ubahn
		case ferry
		case taxi
		case sbahn
		
		var iconImageName : String {
			switch self{
			case .bus:
				return "bus.big"
			case .national:
				return "ice.big"
			case .regional:
				return "re.big"
			case .tram:
				return "tram.big"
			case .ubahn:
				return "u.big"
			case .ferry:
				return "ship.big"
			case .taxi:
				return "taxi.big"
			case .sbahn:
				return "s.big"
			}
		}
		
//		var identi : any ChewAnnotationView.Type {
//			switch self{
//			case .bus:
//				return BusStopAnnotationView.self
//			case .national:
//				return NationalStopAnnotationView.self
//			case .regional:
//				return RegionalStopAnnotationView.self
//			case .tram:
//				return TramStopAnnotationView.self
//			case .ubahn:
//				return UBahnStopAnnotationView.self
//			case .ferry:
//				return FerryStopAnnotationView.self
//			case .taxi:
//				return TaxiStopAnnotationView.self
//			case .sbahn:
//				return SBahnStopAnnotationView.self
//			}
//		}
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
