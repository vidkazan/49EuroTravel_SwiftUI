//
//  SearchLocationViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.09.23.
//

import Foundation
import Combine
import SwiftUI

class SearchLocationViewModel : ObservableObject {
	@FocusState	 var textTopFieldIsFocused : Bool
	@FocusState	 var textBottomFieldIsFocused: Bool
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	@Published private(set) var state : State {
		didSet {
			print(":: searchLocations state: ",state.status.description, state.type)
		}
	}
	
	init(type : LocationDirectionType) {
		let state = State(
			stops: [],
			previousSearchLineString: "",
			status: .idle,
			type: type
		)
		self.state = state
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingLocation()
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
