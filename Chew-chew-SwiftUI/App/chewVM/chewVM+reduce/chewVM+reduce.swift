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
			return reduceJourneyList(state, event)
		case .journeyDetails:
			return reduceJourneyDetails(state, event)
		case .loadingLocation:
			return reduceLoadingLocation(state, event)
		case .settings:
			switch event {
			case .didUpdateSettings(let new):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: new,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case .didDismissBottomSheet:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case .onDatePickerDidPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .datePicker
				)
			case
					.onDepartureEdit,
					.onArrivalEdit,
					.onStopsSwitch,
					.didSetBothLocations,
					.onNewDate,
					.didTapSettings,
					.onNewStop,
					.onJourneyDataUpdated,
					.didLocationButtonPressed,
					.didReceiveLocationData,
					.didFailToLoadLocationData,
					.didStartViewAppear,
					.didLoadInitialData:
						return state
			}
		case .loadingInitialData:
			switch event {
			case .didLoadInitialData(_, let settings):
				return State(
					depStop: .textOnly(""),
					arrStop: .textOnly(""),
					settings: settings,
					// MARK: set timePicker default date here
					timeChooserDate: .now,
					status: .idle
				)
			default:
				return state
			}
		case .start:
			switch event {
			case .didStartViewAppear:
				return State(
					depStop: .textOnly(""),
					arrStop: .textOnly(""),
					settings: ChewSettings(),
					timeChooserDate: state.timeChooserDate,
					status: .loadingInitialData
				)
			default:
				return state
			}
		}
	}
}
