//
//  GeoDTO.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 25.10.23.
//

import Foundation

struct FeatureGeometryDTO : Codable,Equatable,Identifiable {
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

struct PolylineFeatureDTO : Codable,Equatable,Identifiable {
	let id = UUID()
	let type : String?
	let geometry : FeatureGeometryDTO?
	private enum CodingKeys : String, CodingKey {
		case type
		case geometry
	}
}


struct PolylineDTO : Codable,Equatable,Identifiable {
	let id = UUID()
	let type : String?
	let features : [PolylineFeatureDTO]?
	private enum CodingKeys : String, CodingKey {
		case type
		case features
	}
}
