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
	
	static public let cellWidth = UIScreen.main.bounds.width - UIScreen.main.bounds.width/15
	static let stopIdNeuss = 8000274
	
	static var locationIcon : UIImageView {
		let view = UIImageView(image : UIImage(systemName: "location"))
		view.tintColor = .darkGray
		return view
	}
	
	static var flipIcon : UIImageView {
		let view = UIImageView(image : UIImage(systemName: "arrow.up.arrow.down"))
		view.tintColor = .darkGray
		return view
	}
	
	static let Gray49 = UIColor(hue: 0, saturation: 0, brightness: 0.935, alpha: 1)
}
