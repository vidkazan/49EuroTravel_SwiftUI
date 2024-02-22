//
//  Chew_chew_UnitTests.swift
//  Chew-chew-UnitTests
//
//  Created by Dmitrii Grigorev on 26.11.23.
//

//import XCTest
//import CoreLocation
//@testable import Chew_chew_SwiftUI
//
//final class Chew_chew_JourneyTest: XCTestCase {
//	let dataName = Mock.journey.journeyNeussWolfsburg
//	let accuracy = 0.000001
//
//	var APIdecodedData : JourneyWrapper!
//	var actualViewData : JourneyViewData!
//
//
//	override func setUpWithError() throws {
//		let data = dataName.APIDecodedData()
//		self.APIdecodedData = data
//		actualViewData = constructJourneyViewData(
//			journey: Mock.journey.journeyNeussWolfsburg.APIDecodedData()!.journey,
//			depStop: nil,
//			arrStop: nil
//		)
//	}
//
//	func testJourneyViewData() {
//		XCTAssertEqual(actualViewData.badges, [.alertFromRemark,.dticket])
//		XCTAssertEqual(actualViewData.origin,APIdecodedData.journey.legs.first?.origin?.name)
//		XCTAssertEqual(actualViewData.destination,APIdecodedData.journey.legs.last?.destination?.name)
//		XCTAssertEqual(actualViewData.durationLabelText,"5h 7min")
//		XCTAssertEqual(actualViewData.transferCount,2)
//		XCTAssertEqual(actualViewData.startDateString,"27 нояб. 2023")
//		XCTAssertEqual(actualViewData.endDateString,"27 нояб. 2023")
//		XCTAssertEqual(actualViewData.legs.count,5)
//	}
//
//	func testLegType() {
//		XCTAssertEqual(constructLegType(leg: APIdecodedData.journey.legs[0], legs: APIdecodedData.journey.legs),.line)
//		XCTAssertEqual(constructLegType(leg: APIdecodedData.journey.legs[1], legs: APIdecodedData.journey.legs),.line)
//		XCTAssertEqual(constructLegType(leg: APIdecodedData.journey.legs[2], legs: APIdecodedData.journey.legs),.line)
//	}
//
//	func testFirstLeg() {
//		let legs = actualViewData.legs
//
//		let leg = legs.first!
//
//		XCTAssertEqual(leg.legType, .line)
//		XCTAssertNil(leg.delayedAndNextIsNotReachable)
//		XCTAssertEqual(leg.direction, "Minden(Westf)")
//		XCTAssertEqual(leg.duration, "2h 54min")
//		XCTAssertEqual(leg.footDistance, 0)
//		XCTAssertTrue(leg.isReachable)
//		XCTAssertEqual(leg.legBottomPosition, 0.5667752442996743, accuracy: self.accuracy)
//		XCTAssertEqual(leg.legTopPosition, 0,accuracy: self.accuracy)
//		XCTAssertEqual(leg.tripId, APIdecodedData.journey.legs.first?.tripId)
//	}
//
//	func testSecondLeg() {
//		let legs = actualViewData.legs
//
//		let leg = legs[1]
//
//		XCTAssertEqual(leg.legType, .transfer)
//		XCTAssertNil(leg.delayedAndNextIsNotReachable)
//		XCTAssertEqual(leg.direction, "Minden(Westf)")
//		XCTAssertEqual(leg.duration, "5min")
//		XCTAssertEqual(leg.footDistance, 0)
//		XCTAssertTrue(leg.isReachable)
//		XCTAssertEqual(leg.legBottomPosition, 0, accuracy: self.accuracy)
//		XCTAssertEqual(leg.legTopPosition, 0,accuracy: self.accuracy)
//		XCTAssertNil(leg.tripId)
//	}
//
//	func testLastLeg() {
//		let legs = actualViewData.legs
//
//		let leg = legs.last!
//
//		XCTAssertEqual(leg.legType, .line)
//		XCTAssertNil(leg.delayedAndNextIsNotReachable)
//		XCTAssertEqual(leg.direction, "Wolfsburg Hbf")
//		XCTAssertEqual(leg.duration, "55min")
//		XCTAssertEqual(leg.footDistance, 0)
//		XCTAssertTrue(leg.isReachable)
//		XCTAssertEqual(leg.legBottomPosition, 1, accuracy: self.accuracy)
//		XCTAssertEqual(leg.legTopPosition, 0.8208469055374593, accuracy: self.accuracy)
//		XCTAssertEqual(leg.tripId, APIdecodedData.journey.legs.last?.tripId)
//	}
//}
