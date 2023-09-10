//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	func reduceEditingArrivalStop(_ state:  State, _ event: Event) -> State {
		guard case .editingArrivalStop = state.status else { return state }
		switch event {
		case .onDepartureEdit:
			self.topSearchFieldText = ""
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingDepartureStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: [],
				status: .datePicker
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				journeys: state.journeys,
				status: .idle
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: state.status
			)
		case .onNewArrival(let stop):
			self.bottomSearchFieldText = stop?.name ?? "no name"
			return State(
				depStop: state.depStop,
				arrStop: stop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .idle
			)
		default:
			return state
		}
		
	}
}
