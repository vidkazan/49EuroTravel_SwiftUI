//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension ChewViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("⚪🔥 > main event:",event.description,"state:",state.status.description)
		switch state.status {
		case .idle:
			return reduceIdle(state, event)
		case .editingDepartureStop:
			return reduceEditingDepartureStop(state, event)
		case .editingArrivalStop:
			return reduceEditingArrivalStop(state, event)
		case .datePicker:
			return reduceDatePicker(state, event)
		case .journeys:
			return reduceJourneys(state, event)
		case .journeyDetails:
			return reduceJourneyDetails(state, event)
		case .loadingLocation:
			return reduceLoadingLocation(state, event)
		case .settings:
			switch event {
			case .didCloseSettings(let new):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: new,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case
					.onDepartureEdit,
					.onArrivalEdit,
					.onStopsSwitch,
					.didSetBothLocations,
					.onDatePickerDidPressed,
					.didDismissDatePicker,
					.onNewDate,
					.didTapSettings,
					.onNewDeparture,
					.onNewArrival,
					.onJourneyDataUpdated,
					.didLocationButtonPressed,
					.didReceiveLocationData,
					.didFailToLoadLocationData:
						return state
			}
		}
	}
}
