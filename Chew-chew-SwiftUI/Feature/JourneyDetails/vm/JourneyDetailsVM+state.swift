//
//  JourneyDetailsVM+state.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension JourneyDetailsViewModel {
	struct State : Equatable {
		var status : Status
		init(status: Status) {
			self.status = status
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: JourneyDetailsViewModel.Status, rhs: JourneyDetailsViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		
		case idle
		var description : String {
			switch self {
			case .idle:
				return "idle"
			}
		}
	}
	
	enum Event {
	}
}
