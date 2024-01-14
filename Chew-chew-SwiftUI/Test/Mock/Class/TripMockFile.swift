//
//  TripMockFiles.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.11.23.
//

import Foundation

struct TripExpectedData {
	let durationString : String
	let direction : String
}

class TripMockFile : MockFile {
	static let type : MockType = .trip
	
	let rawData : Data?
	let decodedData : TripDTO?
	let expectedData : TripExpectedData
	
	init(_ filename : String,expectedData : TripExpectedData) {
		self.expectedData = expectedData
		
		let rawData = Self.APIRawData(
			url: Self.url(
				type: Self.type,
				fileName: filename
			)
		)
		self.rawData = rawData
		self.decodedData = Self.APIDecodedData(rawData: rawData)
	}
}

class JourneyMockFile : MockFile {
	static let type : MockType = .journey
	
	let rawData : Data?
	let decodedData : JourneyWrapper?
//	let expectedData : TripExpectedData
	
	init(_ filename : String) {
//		self.expectedData = expectedData
		
		let rawData = Self.APIRawData(
			url: Self.url(
				type: Self.type,
				fileName: filename
			)
		)
		self.rawData = rawData
		self.decodedData = Self.APIDecodedData(rawData: rawData)
	}
}
