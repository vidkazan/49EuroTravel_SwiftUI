//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	static func reduceLoadingLocation(_ state:  State, _ event: Event) -> State {
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
		case .onStopEdit(let type):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .editingStop(type)
			)
		case .didTapSheet(let type):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .sheet(type)
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				date: state.date,
				status: .checkingSearchData
			)
		case .onNewStop(let stop, let type):
			switch type {
			case .departure:
				return State(
					depStop: stop,
					arrStop: state.arrStop,
					settings: state.settings,
					date: state.date,
					status: .checkingSearchData
				)
			case .arrival:
				return State(
					depStop: state.depStop,
					arrStop: stop,
					settings: state.settings,
					date: state.date,
					status: .checkingSearchData
				)
			}
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .loadingLocation
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: date,
				status: .checkingSearchData
			)
		case .didReceiveLocationData(let coords):
			return State(
				depStop: .location(Stop(
						coordinates: coords,
						type: .location,
						stopDTO: nil
				)),
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .checkingSearchData
			)
		case .didFailToLoadLocationData:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .idle
			)
		case .didSetBothLocations(let stops):
			return State(
				depStop: .location(stops.departure),
				arrStop: .location(stops.arrival),
				settings: state.settings,
				date: state.date,
				status: .checkingSearchData
			)
		case .didDismissBottomSheet:
			return state
		}
	}
}

