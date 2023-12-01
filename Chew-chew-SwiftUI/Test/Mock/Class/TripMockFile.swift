//
//  TripMockFiles.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 30.11.23.
//

import Foundation
@testable import Chew_chew_SwiftUI

struct TripExpectedData {
	let durationString : String
	let direction : String
}

class TripMockFile : MockFile {
	static let type : MockType = .trip
	
//	let fileName : String
	let rawData : Data?
	let decodedData : Trip?
	let expectedData : TripExpectedData
	
	init(_ filename : String,expectedData : TripExpectedData) {
//		self.fileName = filename
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
