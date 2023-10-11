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
		case .loading:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: .loadedJourneyData
				)
			case .didFailedToLoadJourneyData(let error):
				return State(
					data: state.data,
					status: .error(error: error)
				)
			case .didTapReloadJourneys:
				return state
			case .didExpandLegDetails:
				return state
			case .didTapLocationDetails:
				return state
			case .didCloseLocationDetails:
				return state
			case .didLoadLocationDetails:
				return state
			}
		case .loadedJourneyData:
			switch event {
			case .didExpandLegDetails:
				return state
			case .didLoadJourneyData:
				return state
			case .didFailedToLoadJourneyData:
				return state
			case .didTapReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: self.refreshToken)
				)
			case .didTapLocationDetails(leg: let leg):
				return State(
					data: state.data,
					status: .loadingLocationDetails(leg: leg)
				)
			case .didCloseLocationDetails:
				return state
			case .didLoadLocationDetails:
				return state
			}
		case .error:
			switch event {
			case .didExpandLegDetails:
				return state
			case .didLoadJourneyData:
				return state
			case .didFailedToLoadJourneyData:
				return state
			case .didTapReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: self.refreshToken)
				)
			case .didTapLocationDetails:
				return state
			case .didCloseLocationDetails:
				return state
			case .didLoadLocationDetails:
				return state
			}
		case .locationDetails:
			switch event {
			case .didExpandLegDetails:
				return state
			case .didLoadJourneyData:
				return state
			case .didFailedToLoadJourneyData:
				return state
			case .didTapReloadJourneys:
				return state
			case .didTapLocationDetails:
				return state
			case .didCloseLocationDetails:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case .didLoadLocationDetails:
				return state
			}
		case .loadingLocationDetails:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status
				)
			case .didFailedToLoadJourneyData:
				return state
			case .didTapReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: state.data.refreshToken)
				)
			case .didExpandLegDetails:
				return state
			case .didLoadLocationDetails(let coordRegion, let coordinates):
				return State(
					data: state.data,
					status: .locationDetails(coordRegion: coordRegion, coordinates: coordinates)
				)
			case .didTapLocationDetails:
				return state
			case .didCloseLocationDetails:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			}
		}
	}
}
