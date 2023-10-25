//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceLoadingLocation(_ state:  State, _ event: Event) -> State {
		guard case .loadingLocation = state.status else { return state }
		switch event {
		case .onJourneyDataUpdated:
			return state
		case .onDepartureEdit:
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .editingDepartureStop
			)
		case .onArrivalEdit:
			return State(
				depStop: state.depStop,
				arrStop: nil,
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
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .onNewDeparture(let stop):
			return State(
				depStop: stop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .loadingLocation
			)
		case .onNewArrival:
			return state
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: date,
				status: .idle
			)
		case .didReceiveLocationData(let coords):
			return State(
				depStop: Stop(
					coordinates: coords,
					type: .location,
					stopDTO: nil
				),
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .didFailToLoadLocationData:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
			
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

