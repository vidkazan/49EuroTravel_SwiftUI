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
		init(status: Status, leg: LegViewData) {
			self.status = status
			self.leg = leg
		}
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
	}
	
	enum Event {
		case didtapExpandButton
		var description : String {
			switch self {
			case .didtapExpandButton:
				return "didtapExpandButton"
			}
		}
	}
}
 
