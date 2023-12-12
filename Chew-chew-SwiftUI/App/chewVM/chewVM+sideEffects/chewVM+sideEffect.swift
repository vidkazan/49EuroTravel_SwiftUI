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
			guard case .loadingInitialData(viewContext: let context) = state.status else { return Empty().eraseToAnyPublisher() }
			
			guard let user = ChewUser.basicFetchRequest(context: context) else {
				print("whenLoadingInitialData: user is nil: loading default data")
				return Just(Event.didLoadInitialData(nil,ChewSettings()))
					.eraseToAnyPublisher()
			}
			
			guard let settings = Settings.basicFetchRequest(user: user, context: context) else {
				print("whenLoadingInitialData: settings is nil: loading default data")
				return Just(Event.didLoadInitialData(user,ChewSettings()))
					.eraseToAnyPublisher()
			}
			
			guard let modes = TransportModes.basicFetchRequest(
				modes: ChewSettings().customTransferModes,
				in: settings,
				using: context
			) else {
				print("whenLoadingInitialData: settings is nil: loading default data")
				return Just(Event.didLoadInitialData(user,ChewSettings()))
					.eraseToAnyPublisher()
			}
			
			if let stops = Location.basicFetchRequest(context: context) {
				self.searchStopsViewModel.send(event: .didRecentStopsUpdated(recentStops: stops))
			}
			self.user = user
			self.settings = settings
			self.transportModes = modes
			if let savedJourneys = SavedJourney.basicFetchRequest(context: context) {
				self.savedJourneys = savedJourneys
				self.journeyFollowViewModel.send(
					event: .didUpdateData(savedJourneys.map { elem in
						JourneyFollowData(journeyRef: elem.journeyRef, journeyViewData: nil)
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
				if !settings.isWithTransfers {
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

