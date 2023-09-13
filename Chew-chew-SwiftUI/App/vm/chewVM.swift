//
//  AppVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import Combine

final class ChewViewModel : ObservableObject, Identifiable {
	@Published var topSearchFieldText : String = ""
	@Published var bottomSearchFieldText : String = ""
	@Published private(set) var state : State {
		didSet {
			print("> main state: ",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init() {
		self.state = State(
			depStop: .init(type: "", id: "\(8000274)", name: "Lol", location: nil),
			arrStop: .init(type: "", id: "\(8006552)", name: "Lol", location: nil),
			timeChooserDate: .now, status: .idle)
		Publishers.system(
			initial: State(
				depStop: .init(type: "", id: "\(8000274)", name: "Lol", location: nil),
				arrStop: .init(type: "", id: "\(8006552)", name: "Lol", location: nil),
				  timeChooserDate: .now, status: .idle),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenIdleCheckForSufficientDataForJourneyRequest()
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
