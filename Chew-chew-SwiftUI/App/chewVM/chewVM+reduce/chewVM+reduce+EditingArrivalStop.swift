//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceEditingArrivalStop(_ state:  State, _ event: Event) -> State {
		guard case .editingArrivalStop = state.status else { return state }
		switch event {
		case .onArrivalEdit,
		 .onJourneyDataUpdated,
		 .didLoadInitialData,
		 .didReceiveLocationData,
		 .didFailToLoadLocationData,
		 .didDismissBottomSheet,
		 .didUpdateSettings,
		 .didStartViewAppear,
		 .onNotEnoughSearchData,
		 .didTapCloseJourneyList:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .onDepartureEdit:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .editingDepartureStop
			)
		case .didTapSheet(let type):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .sheet(type)
			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: date,
				status: .checkingSearchData
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				settings: state.settings,
				date: state.date,
				status: .editingDepartureStop
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
		case .didSetBothLocations(let dep, let arr):
			return State(
				depStop: .location(dep),
				arrStop: .location(arr),
				settings: state.settings,
				date: state.date,
				status: .checkingSearchData
			)
		}
	}
}
