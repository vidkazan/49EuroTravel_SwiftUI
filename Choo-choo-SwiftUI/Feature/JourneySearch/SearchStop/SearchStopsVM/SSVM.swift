//
//  SearchStopsViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.09.23.
//

import Foundation
import Combine
import SwiftUI

class SearchStopsViewModel : ObservableObject {
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	@Published private(set) var state : State {
		didSet {
			print("🔎 >> ",state.type ?? "nil","state:",state.status.description)
		}
	}
	
	init() {
		state = State(
			previousStops: [],
			stops: [],
			status: .idle,
			type: nil
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				Self.whenLoadingStops(),
				Self.whenUpdatingRecentStops()
			],
			name: "SSVM"
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
