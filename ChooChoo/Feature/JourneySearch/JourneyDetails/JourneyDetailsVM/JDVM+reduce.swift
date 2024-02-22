//
//  JourneyDetailsVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
extension JourneyDetailsViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print("🚂🔥 >",event.description,"state:",state.status.description)
		switch state.status {
		case .changingSubscribingState:
			switch event {
			case .didFailToChangeSubscribingState:
				return State(
					data: state.data,
					status: .error(error: ApiError.cannotDecodeRawData)
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
				return State(
					data: state.data,
					status: .loadedJourneyData
				)
			case let .didTapReloadButton(id,ref):
				return State(
					data: state.data,
					status: .loading(id: id,token: ref)
				)
			case let .didRequestReloadIfNeeded(id, ref, status):
				return State(
					data: state.data,
					status: .loadingIfNeeded(id: id,token: ref,timeStatus: status)
				)
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
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
			
		case .loadedJourneyData:
			switch event {
			case let .didTapSubscribingButton(id,ref, vm):
				return State(
					data: state.data,
					status: .changingSubscribingState(id: id, ref: ref, journeyDetailsViewModel: vm)
				)
			case let .didTapReloadButton(id,ref):
				return State(
					data: state.data,
					status: .loading(id:id,token: ref)
				)
			case let .didRequestReloadIfNeeded(id, ref, status):
				return State(
					data: state.data,
					status: .loadingIfNeeded(id: id,token: ref,timeStatus: status)
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status.description) \(event.description)")
				return state
			}
			
		case .error:
			switch event {
			case let .didTapSubscribingButton(id,ref, vm):
				return State(
					data: state.data,
					status: .changingSubscribingState(id: id, ref: ref, journeyDetailsViewModel: vm)
				)
			case
					.didLoadJourneyData,
					.didFailedToLoadJourneyData:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case let .didRequestReloadIfNeeded(id, ref, status):
				return State(
					data: state.data,
					status: .loadingIfNeeded(id: id,token: ref,timeStatus: status)
				)
			case let .didTapReloadButton(id,ref):
				return State(
					data: state.data,
					status: .loading(id:id,token: ref)
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status.description) \(event.description)")
				return state
			}
		}
	}
}
