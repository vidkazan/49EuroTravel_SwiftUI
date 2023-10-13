//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceJourneyDetails(_ state:  State, _ event: Event) -> State {
		guard case .journeyDetails = state.status else { return state }
		switch event {
		case .onDepartureEdit:
			return state
		case .onArrivalEdit:
			return state
		case .onDatePickerDidPressed:
			return state
		case .onNewDeparture(_):
			return state
		case .onNewArrival(_):
			return state
		case .onStopsSwitch:
			return state
		case .onNewDate(_):
			return state
		case .onJourneyDataUpdated:
			return state
		case .didLocationButtonPressed:
			return state
		case .didReceiveLocationData:
			return state
		case .didFailToLoadLocationData:
			return state
		case .didSetBothLocations(_, _):
			return state
		case .didDismissDatePicker:
			return state
		}
	}
}
