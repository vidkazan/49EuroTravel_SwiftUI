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
	
	@FocusState	 var textTopFieldIsFocused : Bool
	@FocusState	 var textBottomFieldIsFocused: Bool
	@Published private(set) var state : State {
		didSet {
			print("🔵 >> stops ",state.type ?? "nil","state:",state.status.description)
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
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingStops(),
				self.whenUpdatingRecentStops()
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
