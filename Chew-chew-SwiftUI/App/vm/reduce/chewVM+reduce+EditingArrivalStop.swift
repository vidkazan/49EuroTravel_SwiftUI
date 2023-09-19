//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceEditingArrivalStop(_ state:  State, _ event: Event) -> State {
		guard case .editingArrivalStop = state.status else { return state }
		switch event {
		case .onDepartureEdit:
			self.topSearchFieldText = ""
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .editingDepartureStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
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
		case .onNewArrival(let stop):
			self.bottomSearchFieldText = stop?.stop.name ?? "no name"
			return State(
				depStop: state.depStop,
				arrStop: stop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .onArrivalEdit:
			return state
		case .onNewDeparture:
			return state
		case .onJourneyDataUpdated:
			return state
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .loadingLocation
			)
		case .didReceiveLocationData:
			return state
		case .didFailToLoadLocationData:
			return state
		}
	}
}
