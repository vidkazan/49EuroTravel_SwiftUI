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
	
	static 	func whenLoadingFullLeg() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			guard case .loadingFullLeg(leg: let leg) = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return Self.fetchTrip(tripId: leg.tripId)
				.mapError{ $0 }
				.asyncFlatMap {  res in
					let leg = try res.legViewDataThrows(
						firstTS: DateParcer.getDateFromDateString(dateString: res.plannedDeparture),
						lastTS: DateParcer.getDateFromDateString(dateString: res.plannedArrival),
						legs: nil
					)
					return Event.didLoadFullLegData(data: leg)
				}
				.catch { error in
					state.data.chewVM?.alertViewModel.send(event: .didRequestShow(.fullLegError))
					return Just(Event.didFailToLoadTripData(error: error as! (any ChewError))).eraseToAnyPublisher()
				}
				.eraseToAnyPublisher()
		}
	}
}
