//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension ChewViewModel {
	func transform(_ state: State, _ event: Event){
		if case .didReceiveLocationData = event{
			self.topSearchFieldText = "My Location"
		}
	}
	func reduce(_ state: State, _ event: Event) -> State {
		transform(state, event)
		print("⚪🔥 > main event:",event.description,"state:",state.status.description)
		switch state.status {
		case .idle:
			return reduceIdle(state, event)
		case .editingDepartureStop:
			return reduceEditingDepartureStop(state, event)
		case .editingArrivalStop:
			return reduceEditingArrivalStop(state, event)
		case .datePicker:
			return reduceDatePicker(state, event)
		case .journeys:
			return reduceJourneys(state, event)
		case .journeyDetails:
			return reduceJourneyDetails(state, event)
		case .loadingLocation:
			return reduceLoadingLocation(state, event)
		}
	}
}
