//
//  Constans.swift
//  49EuroTravel
//
//  Created by Dmitrii Grigorev on 05.05.23.
//

import Foundation
import SwiftUI

struct Constants {

	struct apiData {
		static let urlBase = "v6.db.transport.rest"
		static let urlPathStops = "/stops/"
		static let urlPathDepartures = "/departures"
		static let urlPathLocations = "/locations"
		static let urlPathJourneys = "/journeys"
	}
	
	struct CornerRadius {
		static let standart = UIScreen.main.bounds.width/35
		static let small = UIScreen.main.bounds.width/40
		static let tiny = UIScreen.main.bounds.width/50
	}
}
