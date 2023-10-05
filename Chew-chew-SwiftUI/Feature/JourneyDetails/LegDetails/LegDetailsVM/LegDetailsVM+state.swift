//
//  JourneyDetailsVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension LegDetailsViewModel {
	struct State : Equatable {
		let status : Status
		let leg : LegViewData
		let totalProgressHeight : Double
		let currentProgressHeight : Double
		init(status: Status, leg: LegViewData,currentHeight : Double, totalHeight : Double) {
			self.status = status
			self.leg = leg
			self.currentProgressHeight = currentHeight
			self.totalProgressHeight = totalHeight
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: LegDetailsViewModel.Status, rhs: LegDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case idle
		case stopovers
		case disappeared
		
		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .stopovers:
				return "stopovers"
			case .disappeared:
				return "disappeared"
			}
		}
	}
	
	enum Event {
		case didtapExpandButton
		case didUpdateTime
		case didDisappear
		var description : String {
			switch self {
			case .didtapExpandButton:
				return "didtapExpandButton"
			case .didUpdateTime:
				return "didUpdateTime"
			case .didDisappear:
				return "didDisappear"
			}
		}
	}
}
 
