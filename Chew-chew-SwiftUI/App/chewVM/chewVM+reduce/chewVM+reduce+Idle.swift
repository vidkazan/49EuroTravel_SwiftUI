//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceIdle(_ state:  State, _ event: Event) -> State {
		guard case .idle = state.status else { return state }
		switch event {
		case .onJourneyDataUpdated:
			guard let dep = state.depStop,let arr = state.arrStop else {
				return State(depStop: state.depStop,arrStop: state.arrStop, timeChooserDate: state.timeChooserDate, status: .idle)
			}
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .journeys(JourneyListViewModel(depStop: dep, arrStop: arr, timeChooserDate: state.timeChooserDate))
			)
		case .onDepartureEdit:
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .editingDepartureStop
			)
		case .onArrivalEdit:
			return State(
				depStop: state.depStop,
				arrStop: nil,
				timeChooserDate: state.timeChooserDate,
				status: .editingArrivalStop
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .datePicker
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				status:  .idle
			)
		case .onNewDeparture(let stop):
			return State(
				depStop: stop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .loadingLocation
			)
		case .onNewArrival(_):
			return state
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				status: .idle
			)
		case .didReceiveLocationData:
			return state
		case .didFailToLoadLocationData:
			return state
		case .didSetBothLocations(let dep, let arr):
			return State(
				depStop: dep,
				arrStop: arr,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .didDismissDatePicker:
			return state
		}
	}
}

