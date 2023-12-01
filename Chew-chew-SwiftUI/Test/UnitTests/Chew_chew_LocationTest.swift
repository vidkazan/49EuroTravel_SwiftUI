//
//  Chew_chew_UnitTests.swift
//  Chew-chew-UnitTests
//
//  Created by Dmitrii Grigorev on 26.11.23.
//

import XCTest
import CoreLocation
@testable import Chew_chew_SwiftUI
	
	
final class Chew_chew_LocationTest: XCTestCase {
	func testFetchLocations() {
		let client = MockClient()
		let service = ApiService(client: client)

		let _ = service.fetch(
			StopDTO.self,
			query: [Query.location(location: "Pop").getQueryMethod()],
			type: .locations
		)

		XCTAssertEqual(
			client.inputRequest?.url?.query,"query=Pop")
	}
}
