//
//  SearchJourneyVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	func reduceIdle(_ state:  State, _ event: Event) -> State {
		guard case .idle = state.status else { return state }
		switch event {
		case .onJourneyDataUpdated:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .loadingJourneys
			)
		case .onDepartureEdit:
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingDepartureStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onArrivalEdit:
			return State(
				depStop: state.depStop,
				arrStop: nil,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingArrivalStop,
				searchStopViewModel: SearchLocationViewModel(type: .arrival)
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: [],
				status: .datePicker
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .idle
			)
		default:
			return state
		}
	}
}

