//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
#warning("TODO: feature: check when train arrives at starting point")
extension JourneyDetailsViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print("🚂🔥 >",event.description,"state:",state.status.description)
		switch state.status {
		case .changingSubscribingState:
			switch event {
			case .didFailToChangeSubscribingState:
				return State(
					data: state.data,
					status: .error(error: ApiServiceError.cannotDecodeRawData)
				)
			case .didChangedSubscribingState:
				return State(
					data: StateData(currentData: state.data),
					status: .loadedJourneyData
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loading, .loadingIfNeeded:
			switch event {
			case .didCancelToLoadData:
				return State(data: state.data, status: .loadedJourneyData)
			case .didTapReloadButton(ref: let ref):
				return State(data: state.data,status: .loading(token: ref))
			case .didRequestReloadIfNeeded(ref: let ref):
				return State(data: state.data,status: .loadingIfNeeded(token: ref))
			case .didLoadJourneyData(let data):
				return State(
					data: StateData(currentData: state.data, viewData: data),
					status: .loadedJourneyData
				)
			case .didFailedToLoadJourneyData(let error):
				return State(
					data: state.data,
					status: .error(error: error)
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg)
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loadedJourneyData:
			switch event {
			case let .didTapSubscribingButton(ref, vm):
				return State(
					data: state.data,
					status: .changingSubscribingState(ref: ref, journeyDetailsViewModel: vm)
				)
			case .didTapReloadButton(ref: let ref):
				return State(
					data: state.data,
					status: .loading(token: ref)
				)
			case .didRequestReloadIfNeeded(ref: let ref):
				return State(
					data: state.data,
					status: .loadingIfNeeded(token: ref)
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg)
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .error:
			switch event {
			case let .didTapSubscribingButton(ref, vm):
				return State(
					data: state.data,
					status: .changingSubscribingState(ref: ref, journeyDetailsViewModel: vm)
				)
			case .didExpandLegDetails,
				 .didLoadJourneyData,
				 .didFailedToLoadJourneyData:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didRequestReloadIfNeeded(ref: let ref):
				return State(
					data: state.data,
					status: .loadingIfNeeded(token: ref)
				)
			case .didTapReloadButton(ref: let ref):
				return State(
					data: state.data,
					status: .loading(token: ref)
				)
			case .didLongTapOnLeg(leg: let leg):
				return State(
					data: state.data,
					status: .actionSheet(leg: leg)
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .locationDetails:
			switch event {
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loadingLocationDetails:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: StateData(currentData: state.data, viewData: data),
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
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .fullLeg:
			switch event {
			case .didCloseBottomSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .loadingFullLeg:
			switch event {
			case .didCancelToLoadData:
				return State(data: state.data, status: .loadedJourneyData)
			case .didFailToLoadTripData:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case .didLoadJourneyData(let data):
				return State(
					data: StateData(currentData: state.data, viewData: data),
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
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .actionSheet:
			switch event {
			case .didLoadJourneyData(let data):
				return State(
					data: StateData(currentData: state.data, viewData: data),
					status: state.status
				)
			case .didCloseActionSheet:
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case let .didTapBottomSheetDetails(leg, type):
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
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		}
	}
}
