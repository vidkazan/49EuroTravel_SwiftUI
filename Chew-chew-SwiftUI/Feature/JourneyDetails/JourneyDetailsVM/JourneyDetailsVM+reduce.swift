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
			case .didTapReloadJourneys:
				return State(
					data: state.data,
					status: .loading(refreshToken: refreshToken)
				)
			case .didExpandLegDetails:
				return state
			case .didTapLocationDetails:
				return state
			case .didCloseLocationDetails:
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
			case .didTapLocationDetails(coordRegion: let reg, coordinates: let coords):
				return State(
					data: state.data,
					status: .locationDetails(coordRegion: reg,coordinates: coords)
				)
			case .didCloseLocationDetails:
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
			}
		case .locationDetails(coordRegion: let region):
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
					status: .loadedJourneyData(data: state.data)
				)
			}
		}
	}
}
