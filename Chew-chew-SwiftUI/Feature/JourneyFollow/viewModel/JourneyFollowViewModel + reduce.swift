//
//  JourneyFollowViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.12.23.
//

import Foundation
import Combine

extension JourneyFollowViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("📌🔥 > :",event.description,"state:",state.status.description)
		switch state.status {
		case .updatingJourney:
			switch event {
			case .didUpdateData(let data):
				return State(journeys: data, status: .idle)
			case .didFailToUpdateJourney:
				return State(journeys: state.journeys, status: .idle)
			
			case .didFailToEdit,
			 .didTapUpdate,
			 .didRequestUpdateJourney,
			 .didTapEdit,
			 .didEdit:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
			
		case .idle,.error:
			switch event {
			case .didEdit,.didFailToEdit:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didTapUpdate,.didFailToUpdateJourney:
				return state
			case .didUpdateData(let data):
				return State(
					journeys: data,
					status: .idle
				)
			case let .didTapEdit(action, id, data, send):
				return State(
					journeys: state.journeys,
					status: .editing(
						action,
						followId: id,
						followData: data,
						sendToJourneyDetailsViewModel: send
					)
				)
			case let .didRequestUpdateJourney(viewData, followId):
				return State(journeys: state.journeys, status: .updatingJourney(viewData, followId))
				
			}
			
		case .updating:
			switch event {
			case .didUpdateData(let data):
				print(">>> initial",data.map({$0.id}))
				return State(
					journeys: data,
					status: .idle
				)
			case let .didTapEdit(action, id, data, send):
				return State(
					journeys: state.journeys,
					status: .editing(
						action,
						followId: id,
						followData: data,
						sendToJourneyDetailsViewModel: send
					)
				)
			case .didEdit,
				.didTapUpdate,
				.didRequestUpdateJourney,
				.didFailToUpdateJourney,
				.didFailToEdit:
				return state
			}
			
		case .editing:
			switch event {
			case
				.didRequestUpdateJourney,
				.didFailToUpdateJourney,
				.didTapUpdate,
				.didUpdateData,
				.didTapEdit:
				return state
			case .didFailToEdit:
				return State(
					journeys: state.journeys,
					status: .idle
				)
			case .didEdit(let data):
				return State(
					journeys: data,
					status: .idle
				)
			}
		}
	}
}
