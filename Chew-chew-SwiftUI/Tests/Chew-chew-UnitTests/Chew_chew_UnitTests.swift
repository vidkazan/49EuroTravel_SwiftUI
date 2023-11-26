//
//  Chew_chew_UnitTests.swift
//  Chew-chew-UnitTests
//
//  Created by Dmitrii Grigorev on 26.11.23.
//

import XCTest
@testable import Chew_chew_SwiftUI

final class Chew_chew_UnitTests: XCTestCase {

	func testFetchLocations() {
		let client = MockClient()
		let service = ApiService(client: client)
		
		let _ = service.fetch(
			StopDTO.self,
			query: [Query.location(location: "Pop").getQueryMethod()],
			type: .locations
		)
		
		XCTAssertTrue(client.executeCalled)
		XCTAssertEqual(client.requestType, .locations)
		XCTAssertNotNil(client.inputRequest)
		XCTAssertEqual(
			client.inputRequest?.url?.query,"query=Pop")
	}
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
	
}
