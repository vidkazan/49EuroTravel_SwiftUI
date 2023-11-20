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
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .editingArrivalStop
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .datePicker
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: date,
				status: .idle
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .editingArrivalStop
			)
		case .onNewDeparture(let stop):
			return State(
				depStop: stop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .onDepartureEdit,.didLoadInitialData,.onNewArrival,.onJourneyDataUpdated,.didStartViewAppear:
			return state
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .loadingLocation
			)
		case .didReceiveLocationData:
			return state
		case .didFailToLoadLocationData:
			return state
		case .didSetBothLocations(let dep, let arr):
			return State(
				depStop: dep,
				arrStop: arr,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .didDismissBottomSheet:
			return state
		case .didTapSettings:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .settings
			)
		case .didUpdateSettings:
			return state
		}
	}
}

