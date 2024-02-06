//
//  JourneyDetailsVM+sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import Combine
import CoreLocation
import MapKit

extension JourneyDetailsViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		} 
	}
	
	static 	func whenChangingSubscribitionType() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case let .changingSubscribingState(id,_, vm) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			switch state.data.chewVM?.journeyFollowViewModel.state.journeys.contains(where: {$0.id == id}) == true {
			case true:
				state.data.chewVM?.journeyFollowViewModel.send(
					event: .didTapEdit(
						action: .deleting,
						followId: id,
						followData: nil,
						sendToJourneyDetailsViewModel: { event in
							vm?.send(event: event)
						}
					)
				)
			case false:
				state.data.chewVM?.journeyFollowViewModel.send(
					event: .didTapEdit(
						action: .adding,
						followId : id,
						followData: JourneyFollowData(
							id : id,
							journeyViewData: state.data.viewData,
							depStop: state.data.depStop,
							arrStop: state.data.arrStop
						),
						sendToJourneyDetailsViewModel: { event in
							vm?.send(event: event)
						}
					)
				)
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}
