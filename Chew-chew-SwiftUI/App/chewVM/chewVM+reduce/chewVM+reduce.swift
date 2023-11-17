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
			case
					.onDepartureEdit,
					.onArrivalEdit,
					.onStopsSwitch,
					.didSetBothLocations,
					.onDatePickerDidPressed,
					.onNewDate,
					.didTapSettings,
					.onNewDeparture,
					.onNewArrival,
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
			case .didLoadInitialData(let user):
				return State(
					depStop: nil,
					arrStop: nil,
					settings: ChewSettings(),
					// MARK: set timePicker default date here
//					timeChooserDate: .specificDate(user?.timestamp ?? .now),
					timeChooserDate: .now,
					status: .idle
				)
			default:
				return state
			}
		case .start:
			switch event {
			case .didStartViewAppear(let viewContext):
				return State(
					depStop: nil,
					arrStop: nil,
					settings: ChewSettings(),
					timeChooserDate: state.timeChooserDate,
					status: .loadingInitialData(viewContext: viewContext)
				)
			default:
				return state
			}
		}
	}
}
