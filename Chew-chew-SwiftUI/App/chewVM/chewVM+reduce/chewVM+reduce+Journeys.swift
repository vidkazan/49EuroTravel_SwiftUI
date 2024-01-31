//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension ChewViewModel {
	static func reduceJourneyList(_ state:  State, _ event: Event) -> State {
		guard case .journeys = state.status else { return state }
		switch event {
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
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
		case .didUpdateSettings(let new):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: new,
				date: state.date,
				status: .checkingSearchData
			)
		case .onStopEdit(let type):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .editingStop(type)
			)
		case .didTapCloseJourneyList:
			print("reduce: didTapCloseJL")
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .idle
			)
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .loadingLocation)
		case .didReceiveLocationData,
			 .didFailToLoadLocationData,
			 .didSetBothLocations,
			 .didLoadInitialData,
			 .onNewStop,
			 .onJourneyDataUpdated,
			 .onNotEnoughSearchData,
			 .didStartViewAppear:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		}
	}
}

