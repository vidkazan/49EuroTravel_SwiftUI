//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension JourneyListViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print(">> event:",event.description,"for",state.status.description)
		switch state.status {
		case .loadingJourneys:
			return reduceLoadingJourneys(state, event)
		case .journeysLoaded:
			return reduceJourneysLoaded(state, event)
		case .failedToLoadJourneys:
			return reduceFailedToLoadJourneys(state, event)
		}
	}
}
