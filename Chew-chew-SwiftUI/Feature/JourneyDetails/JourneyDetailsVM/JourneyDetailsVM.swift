//
//  JourneyDetailsViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//


import Foundation
import Combine

@MainActor
final class JourneyDetailsViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet {
			print("🟣 > details new state:",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var refreshToken : String?
	var depStop : LocationType?
	var arrStop : LocationType?
	init(refreshToken : String?,data: JourneyViewData,depStop : LocationType?, arrStop : LocationType?) {
		self.refreshToken = refreshToken
		self.depStop = depStop
		self.arrStop = arrStop
		state = State(data: data, status: .loadedJourneyData)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingJourneyByRefreshToken(),
				Self.whenLoadingLocationDetails()
			]
		)
			.assign(to: \.state, on: self)
			.store(in: &bag)
		}
	deinit {
		bag.removeAll()
	}
	func send(event: Event) {
		input.send(event)
	}
}
