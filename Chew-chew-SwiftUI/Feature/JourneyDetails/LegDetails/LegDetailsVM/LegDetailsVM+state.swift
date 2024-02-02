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
		
		var description : String {
			switch self {
			case .idle:
				return "idle"
			case .stopovers:
				return "stopovers"
			}
		}
		
		var evalType : Segments.EvalType {
			switch self {
			case .idle:
				return .collapsed
			case .stopovers:
				return .expanded
			}
		}
	}
	
	enum Event {
		case didTapExpandButton(refTimeTS : Double)
		var description : String {
			switch self {
			case .didTapExpandButton:
				return "didtapExpandButton"
			}
		}
	}
}

