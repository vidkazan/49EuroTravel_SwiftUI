//
//  SearchJourneyVM+reduce+5.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension SearchJourneyViewModel {
	func reduceJourneyDetails(_ state:  State, _ event: Event) -> State {
		guard case .journeyDetails = state.status else { return state }
		switch event {
		case .onBackFromJourneyDetails:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .idle
			)
		default:
			return state
		}
	}
}


