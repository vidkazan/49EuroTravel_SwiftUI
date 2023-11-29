//
//  Mock.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 28.11.23.
//

import Foundation

struct MockFile {
	
	init(_ filename : String,_ type : MockType) {
		self.fileName = filename
		self.type = type
	}
	private let type : MockType
	private let fileName : String
	
	private var url: URL {
		let thisSourceFile = URL(fileURLWithPath: #file)
		let thisDirectory = thisSourceFile.deletingLastPathComponent().deletingLastPathComponent()
		return thisDirectory.appendingPathComponent(type.directoryPath + fileName)
	}
	
	func getData() -> Data? {
		do {
			return try Data(contentsOf: self.url)
		}
		catch {
			print("MockFile: failed to load file" + self.url.path)
			return nil
		}
	}
}

enum MockType {
	case locations
	case journeyList
	case journey
	case trip
	case generic(String)
	
	var directoryPath : String {
		switch self {
		case .locations:
			return "Test/Mock/Locations"
		case .journeyList:
			return "Test/Mock/JourneyList"
		case .journey:
			return "Test/Mock/Journey"
		case .trip:
			return "Test/Mock/Trip"
		case .generic(let path):
			return path
		}
	}
}


struct TripMockFiles {
	static let cancelledFirstStopRE11DussKassel = MockFile("CancelledFirstStop-Trip-RE11-Duss-Kassel.json", .trip)
	static let cancelledLastStopRE11DussKassel = MockFile("CancelledLastStop-Trip-RE11-Duss-Kassel.json", .trip)
	static let RE6NeussMinden = MockFile("RE6-Neuss-Minden.json", .trip)
	static let test = MockFile("Directions.json", .generic(""))
}

struct JourneyMockFiles{
	static let mutlipleAuthors = MockFile("Journey-Neuss-Wolfsburg.json", .journey)
}

struct JourneyListMockFiles {
	static let mutlipleAuthors = MockFile("JourneyList-Neuss-Wolfsburg.json", .journeyList)
}

struct LocationsMockFiles {
//	static let mutlipleAuthors = MockFile("", .locations)
}

enum Mock {
	static let trip = TripMockFiles.self
	static let journeys = JourneyListMockFiles.self
	static let journey = JourneyMockFiles.self
	static let location = LocationsMockFiles.self
}
