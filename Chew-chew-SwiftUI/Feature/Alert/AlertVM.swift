//
//  ALertVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 17.01.24.
//

import Foundation
import Combine
import Network

final class AlertViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet { print("‼️ >  state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var networkMonitor : NetworkMonitor? = nil
	
	
	
	
	
	init(_ initaialStatus : Status = .start) {
		self.state = State(
			status: initaialStatus
		)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadinginitialData()
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



extension AlertViewModel {
	struct State : Equatable {
		let status : Status

		init(status: Status) {
			self.status = status
		}
	}
	
	enum Status : Equatable {
		static func == (lhs: AlertViewModel.Status, rhs: AlertViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case start
		case hidden
		case updating
		case showing
		
		var description : String {
			switch self {
			case .start:
				return "start"
			case .hidden:
				return "hidden"
			case .showing:
				return "showing"
			case .updating:
				return "updating"
			}
		}
	}
	
	enum Event {
		case didLoadInitialData
		case didRequestUpdate
		case didTapDismiss
		case didRequestShow
		var description : String {
			switch self {
			case .didLoadInitialData:
				return "didLoadInitialData"
			case .didTapDismiss:
				return "didTapDismiss"
			case .didRequestShow:
				return "didRequestShow"
			case .didRequestUpdate:
				return "didRequestReload"
			}
		}
	}
}


extension AlertViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print("‼️🔥 > ",event.description,"state:",state.status.description)
		switch state.status {
		case .start:
			switch event {
			case .didLoadInitialData:
				return State(status: .hidden)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .hidden:
			switch event {
			case .didLoadInitialData,.didTapDismiss:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didRequestUpdate:
				return State(
					status: .updating
				)
			case .didRequestShow:
				return State(
					status: .showing
				)
			}
		case .showing:
			switch event {
			case .didLoadInitialData,.didRequestShow:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didRequestUpdate:
				return State(
					status: .updating
				)
			case .didTapDismiss:
				return State(
					status: .hidden
				)
			}
		case .updating:
			switch event {
			case .didLoadInitialData,.didRequestUpdate:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didTapDismiss:
				return State(
					status: .hidden
				)
			case .didRequestShow:
				return State(
					status: .showing
				)
			}
		}
	}
}

extension AlertViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
	
	func whenLoadinginitialData() -> Feedback<State, Event> {
		Feedback { [weak self] (state: State) -> AnyPublisher<Event, Never> in
			guard case .start = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			self?.networkMonitor = NetworkMonitor(alertVM: self)
			return Just(Event.didLoadInitialData).eraseToAnyPublisher()
		}
	}
	
	static func checkInternetConnection(state : State) -> Feedback<State, Event> {
		Feedback {(state: State) -> AnyPublisher<Event, Never> in
			guard case .updating = state.status else {
				return Empty().eraseToAnyPublisher()
			}
			return Empty().eraseToAnyPublisher()
		}
	}
}

