//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceIdle(_ state:  State, _ event: Event) -> State {
		guard case .idle = state.status else { return state }
		switch event {
		case .didLoadInitialData,
				.didStartViewAppear,
				.didReceiveLocationData,
				.didFailToLoadLocationData,
				.didTapCloseJourneyList,
				.onNotEnoughSearchData:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .onJourneyDataUpdated(depStop: let dep, arrStop: let arr):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .journeys(
					JourneyListViewModel(
						chewVM : self,
						depStop: dep,
						arrStop: arr,
						date: state.date,
						settings: state.settings,
						followList: self.journeyFollowViewModel.state.journeys.map { $0.journeyRef }
					)
				)
			)
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
		case .didSetBothLocations(let dep, let arr):
			return State(
				depStop: .location(dep),
				arrStop: .location(arr),
				settings: state.settings,
				date: state.date,
				status: .checkingSearchData
			)
		case .didDismissBottomSheet:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				date: state.date,
				status: .idle
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

