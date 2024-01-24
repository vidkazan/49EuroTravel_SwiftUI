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
		case .didTapCloseJourneyList,
				.onJourneyDataUpdated,
				.didLoadInitialData,
				.didStartViewAppear,
				.onNotEnoughSearchData,
				.didUpdateSettings:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .onDepartureEdit:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .editingDepartureStop
			)
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
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .checkingSearchData
			)
		case .onNewStop(let stop, let type):
			switch type {
			case .departure:
				return State(
					depStop: stop,
					arrStop: state.arrStop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .checkingSearchData
				)
			case .arrival:
				return State(
					depStop: state.depStop,
					arrStop: stop,
					settings: state.settings,
					timeChooserDate: state.timeChooserDate,
					status: .checkingSearchData
				)
			}
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .loadingLocation
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: date,
				status: .checkingSearchData
			)
		case .didReceiveLocationData(let coords):
			return State(
				depStop: .location(
					Stop(
						coordinates: coords,
						type: .location,
						stopDTO: nil
					)
				),
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .checkingSearchData
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
				depStop: .location(dep),
				arrStop: .location(arr),
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .checkingSearchData
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
		}
	}
}

