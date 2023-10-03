//
//  LegDetailsVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.09.23.
//

import Foundation
import Combine

final class LegDetailsViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet {
//			print("🟣 > leg details new state:",state.status.description)
		}
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init(leg : LegViewData) {
		self.state = State(
			status: .idle,
				  leg: leg,
			currentHeight: leg.progressSegments.evaluateCollapsed(time: Date.now.timeIntervalSince1970),
				  totalHeight: leg.heights.totalHeight
			  )
		Publishers.system(
			initial: State(
				status: .idle,
				   leg: leg,
				currentHeight: leg.progressSegments.evaluateCollapsed(time: Date.now.timeIntervalSince1970),
				   totalHeight: leg.heights.totalHeight
			   ),
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
//				self.when()
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
