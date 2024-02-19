//
//  Mock.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 28.11.23.
//

import Foundation
import UIKit

enum Mock {
	static let trip = TripMockFiles.self
	static let journeys = JourneyMockFiles.self
	static let journeyList = JourneyListMockFiles.self
}

struct TripMockFiles {
	static let type = MockFile<TripDTO>.self
	
	static let cancelledMiddleStopsRE6NeussMinden = type.init("cancelledMiddleStops-Trip-RE6-Neuss-Minden")
	static let cancelledFirstStopRE11DussKassel = type.init("cancelledFirstStop-Trip-RE11-Duss-Kassel")
	static let cancelledLastStopRE11DussKassel = type.init("cancelledLastStop-Trip-RE11-Duss-Kassel")
	static let RE6NeussMinden = type.init("re6-Neuss-Minden")
}

struct JourneyMockFiles{
	static let type = MockFile<JourneyWrapper>.self
	
	static let journeyNeussWolfsburg = type.init("journey-Neuss-Wolfsburg")
	static let journeyNeussWolfsburgFirstCancelled = type.init("journey-Neuss-Wolfsburg-First-Cancelled")
	static let journeyNeussWolfsburgMissedConnection = type.init("journey-Neuss-Wolfsburg-missedConnection")
	static let userLocationToStation = type.init("userLocationToStation")
}

struct JourneyListMockFiles {
	static let type = MockFile<JourneyListDTO>.self
	
	static let journeyNeussWolfsburg = type.init("neussWolfsburg")
	static let journeyListPlaceholder = type.init("placeholder")
}
 

class MockFile<T : Decodable> {
	let rawData : Data?
	let decodedData : T?
	
	required init(_ assetName : String) {
		self.rawData = NSDataAsset(name: assetName)?.data
		self.decodedData = Self.decodedData(rawData: rawData)
	}
	
	static func decodedData<T : Decodable>(rawData : Data?) -> T? {
		guard let data = rawData else {
			print(">> mockFile: decodeData: data is nil")
			return nil
		}
		do {
			let res = try JSONDecoder().decode(T.self, from: data)
			return res
		}
		catch {
			print(">> mock JSON decoder error: ",error)
			return nil
		}
	}
}
