//
//  JourneyDetailsViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//


import Foundation
import Combine

final class JourneyDetailsViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet {
			print(">> deatails state: ",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
		
	init() {
		self.state = .init(status: .idle)
		Publishers.system(
			initial: .init(status: .idle),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher())
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
