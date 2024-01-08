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
			guard state.depStop.stop != nil && state.arrStop.stop != nil else { return Empty().eraseToAnyPublisher() }
			return Just(Event.onJourneyDataUpdated)
				.eraseToAnyPublisher()
		}
	}
	
	func whenLoadingInitialData() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingInitialData = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			
			guard let user = self.coreDataStore.fetchUser() else {
				print("whenLoadingInitialData: user is nil: loading default data")
				return Just(Event.didLoadInitialData(nil,ChewSettings()))
					.eraseToAnyPublisher()
			}
			
			guard let settings = user.settings else {
				return Just(Event.didLoadInitialData(user,ChewSettings()))
					.eraseToAnyPublisher()
			}
			let modes = settings.transportModes

			if let stops = self.coreDataStore.fetchLocations() {
				self.searchStopsViewModel.send(event: .didRecentStopsUpdated(recentStops: stops))
			}
			
			if let chewJourneys = self.coreDataStore.fetchJourneys() {
				self.journeyFollowViewModel.send(
					event: .didUpdateData(chewJourneys.map {
						$0.journeyViewData()
					})
				)
			}
			
			var transportModes = Set<LineType>()
			
			// buuueeeeeeee
			
			if modes.bus { transportModes.insert(.bus) }
			if modes.ferry { transportModes.insert(.ferry) }
			if modes.national { transportModes.insert(.national) }
			if modes.nationalExpress { transportModes.insert(.nationalExpress) }
			if modes.regional { transportModes.insert(.regional) }
			if modes.regionalExpress { transportModes.insert(.regionalExpress) }
			if modes.suburban { transportModes.insert(.suburban) }
			if modes.subway { transportModes.insert(.subway) }
			if modes.taxi { transportModes.insert(.taxi) }
			if modes.tram { transportModes.insert(.tram) }
			
			let transferTypes : ChewSettings.TransferTime = {
				if user.settings?.isWithTransfers == false {
					return .direct
				}
				return .time(minutes: Int(settings.transferTime))
			}()
			
			let res = ChewSettings(
				customTransferModes: transportModes,
				transportMode: ChewSettings.TransportMode(
					rawValue: Int(settings.transportModeSegment)) ?? .deutschlandTicket,
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
				self.searchStopsViewModel.send(event: .didChangeFieldFocus(type: .arrival))
			case .editingDepartureStop:
				self.searchStopsViewModel.send(event: .didChangeFieldFocus(type: .departure))
			default:
				break
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}

