//
//  CLLOcationCoordinate2D+hash.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 12.09.23.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Hashable,Equatable{
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
	}
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(latitude)
		hasher.combine(longitude)
	}
}


extension CLLocationCoordinate2D: Identifiable {
	public var id: String {
		"\(latitude)-\(longitude)"
	}
}

extension CLLocation {
	func distance(_ from : CLLocationCoordinate2D) -> CLLocationDistance {
		return self.distance(from: CLLocation(latitude: from.latitude, longitude: from.longitude))
	}
}
