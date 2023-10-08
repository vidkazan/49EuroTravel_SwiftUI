//
//  AppVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import SwiftUI
import Combine

final class ChewViewModel : ObservableObject, Identifiable {
	@ObservedObject var  locationDataManager = LocationDataManager()
	@Published var topSearchFieldText : String = ""
	@Published var bottomSearchFieldText : String = ""
	@Published private(set) var state : State {
		didSet {
			print("⚪ > main new state:",state.status.description)
		}}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init() {
//		state = State(depStop: nil, arrStop: nil, timeChooserDate: .now, status: .idle)
		state = State(
			depStop: .stop(Stop(type: "station", id: "\(586640)", name: "Neuss", address: nil, location: nil, products: nil)),
			arrStop: .stop(Stop(type: "station", id: "\(8089222)", name: "Wob", address: nil, location: nil, products: nil)),
			timeChooserDate: .now,
			status: .idle
		)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenIdleCheckForSufficientDataForJourneyRequest(),
				self.whenLoadingUserLocation()
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
