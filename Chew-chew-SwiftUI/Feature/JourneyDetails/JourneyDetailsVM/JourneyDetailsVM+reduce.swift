//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
// TODO: feature: check when train arrives at starting point
extension JourneyDetailsViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("🟣🔥 > journey details event:",event.description,"state:",state.status.description)
		switch state.status {
		case .loading:
			switch event {
			case 	.didLoadJourneyData(let data):
				return State(
					data: data,
					status: .loadedJourneyData
				)
			case 	.didFailedToLoadJourneyData(let error):
				return State(
					data: state.data,
					status: .error(error: error)
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg)
				)
			case	.didTapReloadJourneys,
					.didCloseActionSheet,
					.didExpandLegDetails,
					.didTapBottomSheetDetails,
					.didCloseBottomSheet,
					.didLoadFullLegData,
					.didLoadLocationDetails:
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
			case .didLoadLocationDetails:
				return state
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg)
				)
			case	.didCloseActionSheet,
					.didTapBottomSheetDetails,
					.didLoadFullLegData,
					.didCloseBottomSheet:
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
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg)
				)
			case	.didLoadLocationDetails,
					.didCloseActionSheet,
					.didTapBottomSheetDetails,
					.didLoadFullLegData,
					.didCloseBottomSheet:
				return state
			}
		case .locationDetails:
			switch event {
			case	.didExpandLegDetails,
					.didLoadJourneyData,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didTapReloadJourneys,
					.didLoadLocationDetails,
					.didLongTapOnLeg,
					.didCloseActionSheet,
					.didTapBottomSheetDetails:
				return state
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			}
		case .loadingLocationDetails:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status
				)
			case .didLoadLocationDetails(let coordRegion, let coordinates,let route):
				return State(
					data: state.data,
					status: .locationDetails(coordRegion: coordRegion, stops: coordinates,route: route)
				)
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case	.didCloseActionSheet,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didExpandLegDetails,
					.didLongTapOnLeg,
					.didTapBottomSheetDetails,
					.didTapReloadJourneys:
				return state
			}
		case .fullLeg:
			switch event {
			case	.didLoadJourneyData,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didTapReloadJourneys,
					.didExpandLegDetails,
					.didLoadLocationDetails,
					.didLongTapOnLeg,
					.didCloseActionSheet,
					.didTapBottomSheetDetails:
				return state
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			}
		case .loadingFullLeg:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status
				)
			case .didLoadFullLegData(let data):
				return State(
					data: state.data,
					status: .fullLeg(leg: data)
				)
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case	.didCloseActionSheet,
					.didFailedToLoadJourneyData,
					.didExpandLegDetails,
					.didLongTapOnLeg,
					.didTapBottomSheetDetails,
					.didTapReloadJourneys,
					.didLoadLocationDetails:
				return state
			}
		case .actionSheet:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status
				)
			case	.didFailedToLoadJourneyData,
					.didTapReloadJourneys,
					.didExpandLegDetails,
					.didLoadLocationDetails,
					.didCloseBottomSheet,
					.didLoadFullLegData,
					.didLongTapOnLeg:
				return state
			case .didCloseActionSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case .didTapBottomSheetDetails(let leg, let type):
				switch type {
				case .locationDetails:
					return State(
						data: state.data,
						status: .loadingLocationDetails(leg: leg)
					)
				case .fullLeg:
					return State(
						data: state.data,
						status: .loadingFullLeg(leg: leg)
					)
				}
			}
		}
	}
}
