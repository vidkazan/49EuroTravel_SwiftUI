//
//  LegDetailsVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 19.09.23.
//

import Foundation
import Combine
//
//final class LegDetailsViewModel : ObservableObject, ChewViewModelProtocol {
//
//	@Published private(set) var state : State
//	private var bag = Set<AnyCancellable>()
//	private  var input = PassthroughSubject<Event,Never>()
//
//
//	init(leg : LegViewData, isExpanded : Bool = false) {
////		print("💾 LDVM \(self.id.uuidString.suffix(4)) init")
//		switch isExpanded {
//		case true:
//			state = State(
//				status: .stopovers,
//				leg: leg,
//				currentHeight: leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .expanded),
//				totalHeight: leg.progressSegments.heightTotalExtended
//			)
//		case false:
//			state = State(
//				status: .idle,
//				leg: leg,
//				currentHeight: leg.progressSegments.evaluate(time: Date.now.timeIntervalSince1970,type: .collapsed),
//				totalHeight: leg.progressSegments.heightTotalCollapsed
//			)
//		}
//
//		Publishers.system(
//			initial: state,
//			reduce: Self.reduce,
//			scheduler: RunLoop.main,
//			feedbacks: [
//				Self.userInput(input: input.eraseToAnyPublisher())
//			],
//			name: leg.lineViewData.name
//		)
//		.weakAssign(to: \.state, on: self)
//		.store(in: &bag)
//	}
//
//	deinit {
//		bag.removeAll()
//	}
//
//	func send(event: Event) {
//		input.send(event)
//	}
//}
//
