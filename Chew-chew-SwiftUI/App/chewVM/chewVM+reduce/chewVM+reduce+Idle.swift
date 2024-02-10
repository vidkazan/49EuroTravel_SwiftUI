//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	static func reduceIdle(_ state:  State, _ event: Event) -> State {
		guard case .idle = state.status else { return state }
		switch event {
		case .didLoadInitialData,
				.didStartViewAppear,
				.didReceiveLocationData,
				.didCancelEditStop,
				.didFailToLoadLocationData,
				.didTapCloseJourneyList,
				.onNotEnoughSearchData:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .onJourneyDataUpdated(let stops):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .journeys(stops)
			)
		case .onStopEdit(let type):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .editingStop(type)
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				date: state.date,
				status:  .checkingSearchData
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
		case .didLocationButtonPressed(send: let send):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .loadingLocation(send: send)
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: date,
				status: .checkingSearchData
			)
		case .didSetBothLocations(let stops):
			return State(
				depStop: .location(stops.departure),
				arrStop: .location(stops.arrival),
				settings: state.settings,
				date: state.date,
				status: .checkingSearchData
			)
		case .didUpdateSettings(let settings):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: settings,
				date: state.date,
				status: .checkingSearchData
			)
		}
	}
}

