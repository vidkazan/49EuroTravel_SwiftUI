//
//  +sideEffect.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Combine
import Foundation
import SwiftUI

extension ChewViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenIdleCheckForSufficientDataForJourneyRequest() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .idle = state.status else { return Empty().eraseToAnyPublisher() }
			guard state.depStop != nil && state.arrStop != nil else { return Empty().eraseToAnyPublisher() }
			return Just(Event.onJourneyDataUpdated)
				.eraseToAnyPublisher()
		}
	}
	
	func whenLoadingInitialData() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingInitialData(viewContext: let context) = state.status else { return Empty().eraseToAnyPublisher() }
			
			guard let user = ChewUser.basicFetchRequest(context: context) else {
				print("whenLoadingInitialData: user is nil: loading default data")
				return Just(Event.didLoadInitialData(nil,ChewSettings()))
					.eraseToAnyPublisher()
			}
			
			if let stops = Location.basicFetchRequest(context: context) {
				self.searchStopsViewModel.send(event: .didRecentStopsUpdated(recentStops: stops))
			}
			self.user = user
			
			var transportModes = Set<LineType>()
			if user.settings.transportModes.bus { transportModes.insert(.bus) }
			if user.settings.transportModes.ferry { transportModes.insert(.ferry) }
			if user.settings.transportModes.national { transportModes.insert(.national) }
			if user.settings.transportModes.nationalExpress { transportModes.insert(.nationalExpress) }
			if user.settings.transportModes.regional { transportModes.insert(.regional) }
			if user.settings.transportModes.regionalExpress { transportModes.insert(.regionalExpress) }
			if user.settings.transportModes.suburban { transportModes.insert(.suburban) }
			if user.settings.transportModes.subway { transportModes.insert(.subway) }
			if user.settings.transportModes.taxi { transportModes.insert(.taxi) }
			if user.settings.transportModes.tram { transportModes.insert(.tram) }
			
			let transferTypes : ChewSettings.TransferTime = {
				if !user.settings.isWithTransfers {
					return .direct
				}
				return .time(minutes: Int(user.settings.transferTime))
			}()
			
			let res = ChewSettings(
				customTransferModes: transportModes,
				transportMode: ChewSettings.TransportMode(
					rawValue: Int(user.settings.transportModeSegment)) ?? .deutschlandTicket,
				transferTime: transferTypes,
				accessiblity: .partial,
				walkingSpeed: .fast,
				language: .english,
				debugSettings: ChewSettings.ChewDebugSettings(prettyJSON: false),
				startWithWalking: true,
				withBicycle: false
			)
			return Just(Event.didLoadInitialData(user,res))
				.eraseToAnyPublisher()
		}
	}
	
	func whenEditingStops() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .editingArrivalStop:
				self.searchStopsViewModel.send(event: .didChangeFieldType(type: .arrival))
			case .editingDepartureStop:
				self.searchStopsViewModel.send(event: .didChangeFieldType(type: .departure))
			default:
				break
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}

