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
			print("⚪ > main new state:",state.status.description, state.depStop?.stop.name,state.arrStop?.stop.name)
		}}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init() {
		self.state = State(depStop: nil, arrStop: nil, timeChooserDate: .now, status: .idle)
//		self.state = State(
//			depStop: .stop(.init(type: "station", id: "\(8000274)", name: "Neuss", address: nil, location: nil, products: nil)),
//			arrStop: .stop(.init(type: "station", id: "\(8006552)", name: "Wob", address: nil, location: nil, products: nil)),
//			timeChooserDate: .now, status: .idle)
		Publishers.system(
			initial:
				State(depStop: nil, arrStop: nil, timeChooserDate: .now, status: .idle),
//				State(
//				depStop: .stop(.init(type: "station", id: "\(8000274)", name: "Neuss", address: nil, location: nil, products: nil)),
//				arrStop: .stop(.init(type: "station", id: "\(8006552)", name: "Wob", address: nil, location: nil, products: nil)),
//				  timeChooserDate: .now, status: .idle),
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
