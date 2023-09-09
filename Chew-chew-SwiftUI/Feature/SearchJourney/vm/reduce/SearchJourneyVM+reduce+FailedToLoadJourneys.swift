//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension SearchJourneyViewModel {
	func reduceFailedToLoadJourneys(_ state:  State, _ event: Event) -> State {
		guard case .failedToLoadJourneys = state.status else { return state }
		switch event {
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .idle
			)
		case .onResetJourneyView:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: [],
				status: .idle
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				journeys: state.journeys,
				status: .idle
			)
		case .onDepartureEdit:
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingDepartureStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onArrivalEdit:
			return State(
				depStop: state.depStop,
				arrStop: nil,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingArrivalStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onDatePickerDidPressed:
			return State(depStop: state.depStop,arrStop: state.arrStop,timeChooserDate: state.timeChooserDate,journeys: [],status: .datePicker)
		default:
			return state
		}
	}
}

