//
//  Mock.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 28.11.23.
//

import Foundation

struct TripMockFiles {
	static let cancelledFirstStopRE11DussKassel = TripMockFile(
		"CancelledFirstStop-Trip-RE11-Duss-Kassel.json",
		expectedData: TripExpectedData(
			durationString: "3h 20min",
			direction: "Kassel-Wilhelmshöhe"
		)
	)
	static let cancelledLastStopRE11DussKassel = TripMockFile(
		"CancelledLastStop-Trip-RE11-Duss-Kassel.json",
		expectedData: TripExpectedData(
			durationString: "3h 20min",
			direction: "Warburg(Westf)"
		)
	)
	static let RE6NeussMinden = TripMockFile(
		"RE6-Neuss-Minden.json",
		expectedData: TripExpectedData(
			durationString: "3h 42min",
			direction: "Minden(Westf)"
		)
	)
}
#warning("make proper expected data")
struct JourneyMockFiles{
	static let journeyNeussWolfsburg = JourneyMockFile("Journey-Neuss-Wolfsburg.json")
}
//
//struct JourneyListMockFiles {
//	static let mutlipleAuthors = MockFile("JourneyList-Neuss-Wolfsburg.json", mockType: .journeyList)
//}
//
//struct LocationsMockFiles {
////	static let mutlipleAuthors = MockFile("", .locations)
//}
