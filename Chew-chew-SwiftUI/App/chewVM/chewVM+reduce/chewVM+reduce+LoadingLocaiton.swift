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
			self.topSearchFieldText = ""
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .editingDepartureStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onArrivalEdit:
			self.bottomSearchFieldText = ""
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
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .onNewDeparture(let stopType):
			return State(
				depStop: stopType,
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
		case .didReceiveLocationData(let lat, let long):
			return State(
				depStop: StopType.location(.init(
					type: "location",
					id: nil,
					name: "My Location",
					address: "My Location",
					location: .init(
						type: "location",
						id: nil,
						latitude: lat,
						longitude: long
					),
					products: nil
				)),
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		case .didFailToLoadLocationData:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)

		}
	}
}
