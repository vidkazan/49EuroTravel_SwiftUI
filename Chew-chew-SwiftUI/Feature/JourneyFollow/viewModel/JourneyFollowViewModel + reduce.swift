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
		case .idle,.error:
			switch event {
			case .didEdit,.didFailToEdit:
				return state
			case .didTapUpdate:
				return state
			case .didUpdateData(let data):
				return State(
					journeys: data,
					status: .idle
				)
			case .didTapEdit(action: let action, journeyRef: let ref, let data, let vm):
				return State(
					journeys: state.journeys,
					status: .editing(
						action,
						journeyRef: ref,
						followData: data,
						journeyDetailsViewModel: vm
					)
				)
			}
		case .updating:
			switch event {
			case .didFailToEdit:
				return state
			case .didTapUpdate:
				return state
			case .didUpdateData(let data):
				return State(
					journeys: data,
					status: .idle
				)
			case .didEdit:
				return state
			case .didTapEdit(action: let action, journeyRef: let ref,let data, let vm):
				return State(
					journeys: state.journeys,
					status: .editing(
						action,
						journeyRef: ref,
						followData: data,
						journeyDetailsViewModel: vm
					)
				)
			}
		case .editing:
			switch event {
			case .didFailToEdit:
				return State(
					journeys: state.journeys,
					status: .idle
				)
			case .didTapUpdate:
				return state
			case .didUpdateData:
				return state
			case .didTapEdit:
				return state
			case .didEdit(let data):
				return State(
					journeys: data,
					status: .idle
				)
			}
		}
	}
}
