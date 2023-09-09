//
//  SearchJourneyVM+reduce+2.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension SearchJourneyViewModel {
	func reduceDatePicker(_ state:  State, _ event: Event) -> State {
		guard case .datePicker = state.status else { return state }
		switch event {
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				journeys: state.journeys,
				status: .idle
			)
		default:
			return state
		}
	}
}

