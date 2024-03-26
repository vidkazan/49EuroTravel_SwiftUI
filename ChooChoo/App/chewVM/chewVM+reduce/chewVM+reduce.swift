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
			case let .didUpdateSearchData(dep,arr,date,journeySettings):
				return State(
					data: StateData(
						data: state.data,
						depStop: dep,
						arrStop: arr,
						journeySettings: journeySettings, 
						date: date
					), 
					status: .checkingSearchData
				)
			case .onJourneyDataUpdated(let stops):
				return State(state: state, status: .journeys(stops))
			case .onNotEnoughSearchData:
				return State(state: state, status: .idle)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loadingInitialData:
			switch event {
			case .didLoadInitialData(let settings):
				return State(data: StateData(data: state.data,journeySettings: settings), status: .idle)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .start:
			switch event {
			case .didStartViewAppear:
				return State(
					data: StateData(
						data: state.data,
						journeySettings: JourneySettings()
					),
					status: .loadingInitialData
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		}
	}
}
