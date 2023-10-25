//
//  GeoDTO.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct FeatureGeometry : Codable,Equatable,Identifiable {
	let id = UUID()
	let type : String?
	// MARK: coordinates[0] : long
	// MARK: coordinates[1] : lat
	let coordinates : [Double]
	private enum CodingKeys : String, CodingKey {
		case type
		case coordinates
	}
}

struct PolylineFeature : Codable,Equatable,Identifiable {
	let id = UUID()
	let type : String?
	let geometry : FeatureGeometry?
	private enum CodingKeys : String, CodingKey {
		case type
		case geometry
	}
}


struct Polyline : Codable,Equatable,Identifiable {
	let id = UUID()
	let type : String?
	let features : [PolylineFeature]?
	private enum CodingKeys : String, CodingKey {
		case type
		case features
	}
}
