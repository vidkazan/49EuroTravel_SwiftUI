//
//  SearchJourneyVM+reduce+1.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceEditingDepartureStop(_ state:  State, _ event: Event) -> State {
		guard case .editingDepartureStop = state.status else { return state }
		switch event {
		case .onArrivalEdit:
			return State(
				depStop: state.depStop,
				arrStop: nil,
				timeChooserDate: state.timeChooserDate,
				status: .editingArrivalStop,
				searchStopViewModel: SearchLocationViewModel(type: .arrival)
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .datePicker
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				status: .idle
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				status: state.status
			)
		case .onNewDeparture(let stop):
			self.topSearchFieldText = stop?.name ?? "no name"
			return State(
				depStop: stop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		default:
			return state
		}
	}
}

