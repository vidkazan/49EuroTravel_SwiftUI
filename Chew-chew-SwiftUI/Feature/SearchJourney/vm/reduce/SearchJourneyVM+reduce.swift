//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print(">> event:",event.description,"for",state.status.description)
		switch state.status {
			case .idle:
			return reduceIdle(state, event)
		case .editingDepartureStop:
			return reduceEditingDepartureStop(state, event)
		case .editingArrivalStop:
			return reduceEditingArrivalStop(state, event)
		case .datePicker:
			return reduceDatePicker(state, event)
		case .loadingJourneys:
			return reduceLoadingJourneys(state, event)
		case .journeysLoaded:
			return reduceJourneysLoaded(state, event)
		case .journeyDetails:
			return reduceJourneyDetails(state, event)
		case .failedToLoadJourneys:
			return reduceFailedToLoadJourneys(state, event)
		}
	}
}
