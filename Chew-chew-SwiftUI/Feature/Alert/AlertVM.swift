//
//  ALertVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 17.01.24.
//

import Foundation
import Combine
import Network
import SwiftUI

final class AlertViewModel : ObservableObject, Identifiable {

	@Published private(set) var state : State {
		didSet { print("‼️‼️ >  state:",state.alert.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init() {
		self.state = State(alert: .none)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher())
			],
			name: "AVM"
		)
		.weakAssign(to: \.state, on: self)
		.store(in: &bag)
	}
	
	deinit {
		bag.removeAll()
	}

	func send(event: Event) {
		input.send(event)
	}
}



extension AlertViewModel {
	enum AlertType : Equatable {
		static func == (lhs: AlertViewModel.AlertType, rhs: AlertViewModel.AlertType) -> Bool {
			lhs.description == rhs.description
		}
		
		case none
		case destructive(destructiveAction : ()->Void, description : String, actionDescription : String)
		
		var description : String {
			switch self {
			case .none:
			return "none"
			case let .destructive(_, name,_):
				return "destructive \(name)"
			}
		}
	}
	
	struct State : Equatable {
		let alert : AlertType
	}
	
	enum Event {
		case didRequestDismiss(_ type: AlertType)
		case didRequestShow(_ type: AlertType)
		var description : String {
			switch self {
			case .didRequestDismiss:
				return "didTapDismiss"
			case .didRequestShow:
				return "didRequestShow"
			}
		}
	}
}


extension AlertViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print("‼️🔥 > ",event.description,"state:",state.alert)
		switch event {
		case .didRequestShow(let type):
			return State(alert: type)
		case .didRequestDismiss:
			return State(alert: .none)
		}
	}
}

extension AlertViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
}

