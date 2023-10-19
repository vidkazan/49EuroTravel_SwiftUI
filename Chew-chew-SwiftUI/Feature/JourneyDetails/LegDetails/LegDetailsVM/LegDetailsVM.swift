//
//  LegDetailsVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.09.23.
//

import Foundation
import Combine

final class LegDetailsViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init(leg : LegViewData, isExpanded : Bool = false) {
		switch isExpanded {
		case true:
			state = State(
				status: .stopovers,
				leg: leg,
				currentHeight: leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .expanded),
				totalHeight: leg.progressSegments.heightTotalExtended
			)
		case false:
			state = State(
				status: .idle,
				leg: leg,
				currentHeight: leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .collapsed),
				totalHeight: leg.progressSegments.heightTotalCollapsed
			)
		}
		
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				//				Self.updateByTimer()
			]
		)
		.assign(to: \.state, on: self)
		.store(in: &bag)
	}
	
	deinit {
		bag.removeAll()
	}
	func cleanup(){
		
	}
	func send(event: Event) {
		input.send(event)
	}
}
