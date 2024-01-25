//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension ChewViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("📱🔥 > ",event.description,"state:",state.status.description)
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
		case .checkingSearchData:
			switch event {
			case .onJourneyDataUpdated(let dep, let arr):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .journeys(
						JourneyListViewModel(
							depStop: dep,
							arrStop: arr,
							timeChooserDate: state.timeChooserDate,
							settings: state.settings,
							followList: self.journeyFollowViewModel.state.journeys.map { $0.journeyRef }
						)
					)
				)
			case .onNotEnoughSearchData:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .settings:
			switch event {
			case .didUpdateSettings(let new):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: new,
					timeChooserDate: state.timeChooserDate,
					status: .checkingSearchData
				)
			case .didDismissBottomSheet:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case .didTapDatePicker:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .datePicker
				)
			case
					.onDepartureEdit,
					.didTapCloseJourneyList,
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
					.didLoadInitialData,
					.onNotEnoughSearchData:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
						return state
			}
		case .loadingInitialData:
			switch event {
			case .didLoadInitialData(let settings):
				return State(
					depStop: .textOnly(""),
					arrStop: .textOnly(""),
					settings: settings,
					// MARK: set timePicker default date here
					timeChooserDate: .now,
					status: .idle
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
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
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		}
	}
}
