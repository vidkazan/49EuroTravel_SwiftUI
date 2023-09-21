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
			print("🟣 > details new state:",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var refreshToken : String?
	
	init(refreshToken : String?,data: JourneyCollectionViewData) {
		self.refreshToken = refreshToken
		self.state = .init(data: data, status: .loading(refreshToken: refreshToken))
		Publishers.system(
			initial: .init(data: data, status: .loading(refreshToken: refreshToken)),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
//				self.whenLoadingJourneyByRefreshToken(),
				self.whenLoadingData()
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
