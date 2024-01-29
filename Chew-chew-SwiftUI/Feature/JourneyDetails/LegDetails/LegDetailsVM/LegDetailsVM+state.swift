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
		let data : StateData
		init(data : StateData,status: Status) {
			self.data = data
			self.status = status
		}
		
		init(status: Status, leg: LegViewData,currentHeight : Double, totalHeight : Double) {
			self.data = StateData(
				leg: leg,
				totalProgressHeight: totalHeight,
				currentProgressHeight: currentHeight
			)
			self.status = status
		}
	}
	
	struct StateData : Equatable {
		let leg : LegViewData
		let totalProgressHeight : Double
		let currentProgressHeight : Double
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
		case didTapExpandButton
		case didDisappear
		var description : String {
			switch self {
			case .didTapExpandButton:
				return "didtapExpandButton"
			case .didDisappear:
				return "didDisappear"
			}
		}
	}
}

