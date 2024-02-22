//
//  Chew_chew_UnitTests.swift
//  Chew-chew-UnitTests
//
//  Created by Dmitrii Grigorev on 26.11.23.
//

import CoreLocation
import XCTest
@testable import Chew_chew_SwiftUI

final class Chew_chew_TripTest: XCTestCase {
	func testNormalTrip() {
		runTest(with: Mock.trip.RE6NeussMinden)
	}
	
	func testTripCancelledFirstStop() {
		runTest(with: Mock.trip.cancelledFirstStopRE11DussKassel)
	}
	
	func testTripCancelledLastStop() {
		runTest(with: Mock.trip.cancelledLastStopRE11DussKassel)
	}
}

extension Chew_chew_TripTest {
	fileprivate func runTest(with data: TripMockFile) {
		let actualViewData: LegViewData = constructLegData(
			leg: data.decodedData!.trip,
			firstTS: .now,
			lastTS: .now,
			legs: nil
		)!
		
		XCTAssertEqual(actualViewData.duration, data.expectedData.durationString)
		XCTAssertEqual(actualViewData.direction, data.expectedData.direction)
	}

}
