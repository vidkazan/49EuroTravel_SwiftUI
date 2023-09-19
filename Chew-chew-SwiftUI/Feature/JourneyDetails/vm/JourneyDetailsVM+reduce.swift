//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension JourneyDetailsViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("🟣🔥 > details event:",event.description,"state:",state.status.description)
		switch state.status {
		case .loading(refreshToken: let refreshToken):
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: state.data,
					status: .loadedJourneyData(data: data)
				)
			case .didFailedToLoadJourneyData(let error):
				return State(
					data: state.data,
					status: .error(error: error)
				)
			case .didReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: refreshToken)
				)
			}
		case .loadedJourneyData:
			switch event {
			case .didLoadJourneyData:
				return state
			case .didFailedToLoadJourneyData:
				return state
			case .didReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: self.refreshToken)
				)
			}
		case .error:
			switch event {
			case .didLoadJourneyData:
				return state
			case .didFailedToLoadJourneyData:
				return state
			case .didReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: self.refreshToken)
				)
			}
		}
	}
}
