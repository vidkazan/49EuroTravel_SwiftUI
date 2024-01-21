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
		print("🚂🔥 >",event.description,"state:",state.status.description)
		switch state.status {
		case .changingSubscribingState:
			switch event {
			case .didFailToChangeSubscribingState:
				return State(
					data: state.data,
					status: .error(error: .cannotDecodeRawData),
					isFollowed: state.isFollowed
				)
			case .didChangedSubscribingState(let isFollowed):
				return State(
					data: state.data,
					status: .loadedJourneyData,
					isFollowed: isFollowed
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loading, .loadingIfNeeded:
			switch event {
			case .didTapReloadButton:
				return State(
					data: state.data,
					status: .loading(token: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didRequestReloadIfNeeded:
				return State(
					data: state.data,
					status: .loadingIfNeeded(token: self.refreshToken),
					isFollowed: state.isFollowed
				)
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
			case	.didCloseActionSheet,
					.didFailToChangeSubscribingState,
					.didExpandLegDetails,
					.didTapBottomSheetDetails,
					.didCloseBottomSheet,
					.didLoadFullLegData,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didLoadLocationDetails:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loadedJourneyData:
			switch event {
			case .didTapSubscribingButton(let ref):
				return State(
					data: state.data,
					status: .changingSubscribingState(ref: ref),
					isFollowed: state.isFollowed
				)
			case .didTapReloadButton:
				return State(
					data: state.data,
					status: .loading(token: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didRequestReloadIfNeeded:
				return State(
					data: state.data,
					status: .loadingIfNeeded(token: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg),
					isFollowed: state.isFollowed
				)
			case .didExpandLegDetails,
					.didLoadJourneyData,
					.didFailedToLoadJourneyData,
					.didLoadLocationDetails,
					.didCloseActionSheet,
					.didFailToChangeSubscribingState,
					.didChangedSubscribingState,
					.didTapBottomSheetDetails,
					.didLoadFullLegData,
					.didCloseBottomSheet:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .error:
			switch event {
			case .didTapSubscribingButton(let ref):
				return State(
					data: state.data,
					status: .changingSubscribingState(ref: ref),
					isFollowed: state.isFollowed
				)
			case .didExpandLegDetails,
				 .didLoadJourneyData,
				 .didFailedToLoadJourneyData:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didRequestReloadIfNeeded:
				return State(
					data: state.data,
					status: .loadingIfNeeded(token: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didTapReloadButton:
				return State(
					data: state.data,
					status: .loading(token: self.refreshToken),
					isFollowed: state.isFollowed
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg),
					isFollowed: state.isFollowed
				)
			case	.didLoadLocationDetails,
					.didFailToChangeSubscribingState,
					.didCloseActionSheet,
					.didTapBottomSheetDetails,
					.didLoadFullLegData,
					.didChangedSubscribingState,
					.didCloseBottomSheet:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .locationDetails:
			switch event {
			case	.didExpandLegDetails,
					.didFailToChangeSubscribingState,
					.didLoadJourneyData,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didTapReloadButton,
					.didLoadLocationDetails,
					.didLongTapOnLeg,
					.didCloseActionSheet,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didRequestReloadIfNeeded,
					.didTapBottomSheetDetails:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
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
					.didFailToChangeSubscribingState,
					.didRequestReloadIfNeeded,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didExpandLegDetails,
					.didLongTapOnLeg,
					.didTapBottomSheetDetails,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didTapReloadButton:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .fullLeg:
			switch event {
			case	.didLoadJourneyData,
					.didFailToChangeSubscribingState,
					.didLoadFullLegData,
					.didFailedToLoadJourneyData,
					.didTapReloadButton,
					.didExpandLegDetails,
					.didLoadLocationDetails,
					.didLongTapOnLeg,
					.didCloseActionSheet,
					.didRequestReloadIfNeeded,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didTapBottomSheetDetails:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
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
					.didFailToChangeSubscribingState,
					.didFailedToLoadJourneyData,
					.didExpandLegDetails,
					.didLongTapOnLeg,
					.didTapBottomSheetDetails,
					.didRequestReloadIfNeeded,
					.didTapReloadButton,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didLoadLocationDetails:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
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
					.didFailToChangeSubscribingState,
					.didTapReloadButton,
					.didRequestReloadIfNeeded,
					.didExpandLegDetails,
					.didLoadLocationDetails,
					.didCloseBottomSheet,
					.didLoadFullLegData,
					.didChangedSubscribingState,
					.didTapSubscribingButton,
					.didLongTapOnLeg:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
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
