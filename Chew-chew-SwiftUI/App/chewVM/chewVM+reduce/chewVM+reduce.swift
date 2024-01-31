//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension ChewViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print("📱🔥 > ",event.description,"state:",state.status.description)
		switch state.status {
		case .idle:
			return reduceIdle(state, event)
		case .editingStop:
			return reduceEditingStop(state, event)
		case .journeys:
			return reduceJourneyList(state, event)
		case .loadingLocation:
			return reduceLoadingLocation(state, event)
		case .checkingSearchData:
			switch event {
			case .didUpdateSettings(let new):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: new,
					date: state.date,
					status: .checkingSearchData
				)
			case .onNewDate(let date):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					date: date,
					status: .checkingSearchData
				)
			case .onJourneyDataUpdated(let stops):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					date: state.date,
					status: .journeys(stops)
				)
			case .onNotEnoughSearchData:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					settings: state.settings,
					date: state.date,
					status: .idle
				)
			default:
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
					date: .now,
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
					date: state.date,
					status: .loadingInitialData
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		}
	}
}
