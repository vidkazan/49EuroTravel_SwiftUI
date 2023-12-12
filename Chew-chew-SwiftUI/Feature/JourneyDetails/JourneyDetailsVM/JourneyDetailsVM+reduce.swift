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
		case .changingSubscribingState:
			switch event {
			case .didChangedSubscribingState(let isFollowed):
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: isFollowed
				)
			default:
				return state
			}
		case .loading:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: .loadedJourneyData,
					isFollowed: state.isFollowed
				)
			case 	.didFailedToLoadJourneyData(let error):
				return State(
					data: state.data,
					status: .error(error: error),
					isFollowed: state.isFollowed
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg),
					isFollowed: state.isFollowed
				)
			case	.didTapReloadJourneyList,
					.didCloseActionSheet,
					.didExpandLegDetails,
					.didTapBottomSheetDetails,
					.didCloseBottomSheet,
					.didLoadFullLegData,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didLoadLocationDetails:
				return state
			}
		case .loadedJourneyData:
			switch event {
			case .didTapSubscribingButton:
				return State(
					data: state.data,
					status: .changingSubscribingState,
					isFollowed: state.isFollowed
				)
			case .didExpandLegDetails:
				return state
			case .didLoadJourneyData:
				return state
			case .didFailedToLoadJourneyData:
				return state
			case .didTapReloadJourneyList:
				return State(
					data: state.data,
					status: .loading(refreshToken: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didLoadLocationDetails:
				return state
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg),
					isFollowed: state.isFollowed
				)
			case	.didCloseActionSheet,
					.didChangedSubscribingState,
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
			case .didTapReloadJourneyList:
				return State(
					data: state.data,
					status: .loading(refreshToken: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg),
					isFollowed: state.isFollowed
				)
			case	.didLoadLocationDetails,
					.didCloseActionSheet,
					.didTapBottomSheetDetails,
					.didLoadFullLegData,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didCloseBottomSheet:
				return state
			}
		case .locationDetails:
			switch event {
			case	.didExpandLegDetails,
					.didLoadJourneyData,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didTapReloadJourneyList,
					.didLoadLocationDetails,
					.didLongTapOnLeg,
					.didCloseActionSheet,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didTapBottomSheetDetails:
				return state
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: state.isFollowed
				)
			}
		case .loadingLocationDetails:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status,
					isFollowed: state.isFollowed
				)
			case .didLoadLocationDetails(let coordRegion, let coordinates,let route):
				return State(
					data: state.data,
					status: .locationDetails(coordRegion: coordRegion, stops: coordinates,route: route),
					isFollowed: state.isFollowed
				)
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: state.isFollowed
				)
			case	.didCloseActionSheet,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didExpandLegDetails,
					.didLongTapOnLeg,
					.didTapBottomSheetDetails,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didTapReloadJourneyList:
				return state
			}
		case .fullLeg:
			switch event {
			case	.didLoadJourneyData,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didTapReloadJourneyList,
					.didExpandLegDetails,
					.didLoadLocationDetails,
					.didLongTapOnLeg,
					.didCloseActionSheet,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didTapBottomSheetDetails:
				return state
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: state.isFollowed
				)
			}
		case .loadingFullLeg:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status,
					isFollowed: state.isFollowed
				)
			case .didLoadFullLegData(let data):
				return State(
					data: state.data,
					status: .fullLeg(leg: data),
					isFollowed: state.isFollowed
				)
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: state.isFollowed
				)
			case	.didCloseActionSheet,
					.didFailedToLoadJourneyData,
					.didExpandLegDetails,
					.didLongTapOnLeg,
					.didTapBottomSheetDetails,
					.didTapReloadJourneyList,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didLoadLocationDetails:
				return state
			}
		case .actionSheet:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: data,
					status: state.status,
					isFollowed: state.isFollowed
				)
			case	.didFailedToLoadJourneyData,
					.didTapReloadJourneyList,
					.didExpandLegDetails,
					.didLoadLocationDetails,
					.didCloseBottomSheet,
					.didLoadFullLegData,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didLongTapOnLeg:
				return state
			case .didCloseActionSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: state.isFollowed
				)
			case .didTapBottomSheetDetails(let leg, let type):
				switch type {
				case .locationDetails:
					return State(
						data: state.data,
						status: .loadingLocationDetails(leg: leg),
						isFollowed: state.isFollowed
					)
				case .fullLeg:
					return State(
						data: state.data,
						status: .loadingFullLeg(leg: leg),
						isFollowed: state.isFollowed
					)
				}
			}
		}
	}
}
