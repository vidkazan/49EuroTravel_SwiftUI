//
//  SearchJourneyVM+reduce+4.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	func reduceJourneysLoaded(_ state:  State, _ event: Event) -> State {
		guard case .journeysLoaded = state.status else { return state }
		switch event {
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				journeys: state.journeys,
				status: .idle
			)
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .idle
			)
		case .onResetJourneyView:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: [],
				status: .idle
			)
		case .onDepartureEdit:
			self.topSearchFieldText = ""
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingDepartureStop
			)
		case .onArrivalEdit:
			self.bottomSearchFieldText = ""
			return State(
				depStop: state.depStop,
				arrStop: nil,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .editingArrivalStop
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: [],
				status: .datePicker
			)
		case .onReloadJourneys, .onLaterRef, .onEarlierRef:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: state.journeys,
				status: .loadingJourneys
			)
		case .onJourneyDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				journeys: [],
				status: .journeyDetails
			)
		default:
			return state
		}
	}
}

