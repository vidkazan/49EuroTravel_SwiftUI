//
//  SearchJourneyVM+reduce+.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension ChewViewModel {
	func reduceJourneys(_ state:  State, _ event: Event) -> State {
		guard case .journeys = state.status else { return state }
		switch event {
		case .onStopsSwitch:
			return State(
				depStop: state.arrStop,
				arrStop: state.depStop,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
//		case .onResetJourneyView:
//			return State(
//				depStop: state.depStop,
//				arrStop: state.arrStop,
//				timeChooserDate: state.timeChooserDate,
//				status: .idle
//			)
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: date,
				status: .idle
			)
		case .onDepartureEdit:
			self.topSearchFieldText = ""
			return State(
				depStop: nil,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .editingDepartureStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onArrivalEdit:
			self.bottomSearchFieldText = ""
			return State(
				depStop: state.depStop,
				arrStop: nil,
				timeChooserDate: state.timeChooserDate,
				status: .editingArrivalStop,
				searchStopViewModel: SearchLocationViewModel(type: .departure)
			)
		case .onDatePickerDidPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .datePicker)
		case .onNewDeparture(_):
			return state
		case .onNewArrival(_):
			return state
		case .onJourneyDataUpdated:
			return state
		case .onBackFromJourneyDetails:
			return state
		case .didLocationButtonPressed:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				timeChooserDate: state.timeChooserDate,
				status: .loadingLocation)
		case .didReceiveLocaitonData:
			return state
		case .didFailToLoadLocationData:
			return state
		}
	}
}

