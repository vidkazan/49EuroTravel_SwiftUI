//
//  AppVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation
import CoreData

#warning("TODO: sort stops by closest location")
#warning("TODO: delete recent stops")
#warning("TODO: recent stops duplication")
final class ChewViewModel : ObservableObject, Identifiable {
	let referenceDate : ChewDate
	@Published private(set) var state : State {
		didSet { print("📱 >  state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init (
		initialState : State = State(),
		referenceDate : ChewDate = .now
	) {
		self.state = initialState
		self.referenceDate = referenceDate
		
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenIdleCheckForSufficientDataForJourneyRequest(),
				Self.whenLoadingUserLocation(),
				Self.whenLoadingInitialData(),
				Self.whenEditingStops()
			],
			name: "ChewVM"
		)
		.weakAssign(to: \.state, on: self)
		.store(in: &bag)
	}
	deinit {
		bag.removeAll()
	}
	
	func send(event: Event) {
		input.send(event)
	}
}

extension ChewViewModel {
	
}
