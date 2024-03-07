//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	static func reduceEditingStop(_ state:  State, _ event: Event) -> State {
		guard case .editingStop(let type) = state.status else { return state }
		switch event {
		case .onJourneyDataUpdated,
				.didLoadInitialData,
				.didReceiveLocationData,
				.didFailToLoadLocationData,
				.didUpdateSettings,
				.didStartViewAppear,
				.onNotEnoughSearchData,
				.didTapCloseJourneyList:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .didCancelEditStop:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .idle
			)
		case .onStopEdit(let type):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .editingStop(type)
			)
		case let .onNewDate(date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: date,
				status: .checkingSearchData
			)
		case .onStopsSwitch:
			let newType : LocationDirectionType = {
				switch type {
				case .departure:
					return .arrival
				case .arrival:
					return .departure
				}
			}()
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				date: state.date,
				status: .editingStop(newType)
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
			switch Model.shared.searchStopsViewModel.state.status {
			case .loading:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					date: state.date,
					status: .idle
				)
			default:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					date: state.date,
					status: .loadingLocation(send: send)
				)
			}
		case .didSetBothLocations(let stops,let date):
			return State(
				depStop: .location(stops.departure),
				arrStop: .location(stops.arrival),
				settings: state.settings,
				date: date ?? state.date,
				status: .checkingSearchData
			)
		}
	}
}
