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
		didSet { print("‼️ >  state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var networkMonitor : NetworkMonitor? = nil
	
	init(_ initaialStatus : Status = .start, alerts : Set<AlertType> = Set<AlertType>() ) {
		self.state = State(
			alerts: alerts,
			status: initaialStatus
		)
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadinginitialData(),
				Self.whenEditing()
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
	enum Action {
		case none
		case dismiss
		case reload(_ perform: () -> Void)
		
		var iconName : String {
			switch self {
			case .dismiss:
				return "xmark.circle"
			case .none:
				return ""
			case .reload:
				return "arrow.clockwise"
			}
		}
		func alertViewModelEvent(alertType : AlertType) -> AlertViewModel.Event? {
			switch self {
			case .dismiss:
				return .didRequestDismiss(alertType)
			case .none:
				return nil
			case .reload:
				return nil
			}
		}
	}
	enum AlertType : Equatable, Hashable, Comparable {
		static func < (lhs: AlertViewModel.AlertType, rhs: AlertViewModel.AlertType) -> Bool {
			return lhs.id < rhs.id
		}

		case offlineMode
		case fullLegError
		case userLocationError
		case journeyFollowError(type : JourneyFollowViewModel.Action)
		
		var id : Int {
			switch self {
			case .fullLegError:
				return 3
			case .journeyFollowError:
				return 2
			case .offlineMode:
				return 0
			case .userLocationError:
				return 1
			}
		}
		var bgColor : Color {
			switch self {
			case .fullLegError:
				return Color.chewFillRedPrimary.opacity(0.5)
			case .journeyFollowError:
				return Color.chewFillRedPrimary.opacity(0.5)
			case .offlineMode:
				return Color.chewFillBluePrimary
			case .userLocationError:
				return Color.chewFillRedPrimary.opacity(0.5)
			}
		}
		
		var action : Action {
			switch self {
			case .fullLegError:
				return .dismiss
			case .journeyFollowError:
				return .dismiss
			case .offlineMode:
				return .none
			case .userLocationError:
				return .dismiss
			}
		}
		
		var infoAction : (() -> Void)? {
			switch self {
			case .fullLegError:
				return nil
			case .journeyFollowError:
				return nil
			case .offlineMode:
				return nil
			case .userLocationError:
				return {
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,options: [:], completionHandler: nil)
				}
			}
		}
		
		var badgeType : Badges {
			switch self {
			case .fullLegError:
				return .fullLegError
			case .journeyFollowError(type: let action):
				return .followError(action)
			case .offlineMode:
				return .offlineMode
			case .userLocationError:
				return .locationError
			}
		}
	}
	struct State : Equatable {
		let alerts : Set<AlertType>
		let status : Status
	}
	
	enum Status : Equatable, Hashable {
		static func == (lhs: AlertViewModel.Status, rhs: AlertViewModel.Status) -> Bool {
			return lhs.description == rhs.description
		}
		case start
		case adding(_ type: AlertType)
		case showing
		case deleting(_ type: AlertType)
		
		var description : String {
			switch self {
			case .adding:
				return "adding"
			case .deleting:
				return "deleting"
			case .start:
				return "start"
			case .showing:
				return "showing"
			}
		}
	}
	
	enum Event {
		case didLoadInitialData
		case didDismiss(_ types: Set<AlertType>)
		case didAdd(_ types: Set<AlertType>)
		case didRequestDismiss(_ type: AlertType)
		case didRequestShow(_ type: AlertType)
		var description : String {
			switch self {
			case .didAdd:
				return "didAdd"
			case .didDismiss:
				return "didDismiss"
			case .didLoadInitialData:
				return "didLoadInitialData"
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
		print("‼️🔥 > ",event.description,"state:",state.status.description)
		switch state.status {
		case .start:
			switch event {
			case .didLoadInitialData:
				return State(
					alerts: Set<AlertType>(),
					status: .showing
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .showing:
			switch event {
			case .didLoadInitialData,.didAdd,.didDismiss:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			case .didRequestShow(let type):
				return State(
					alerts: state.alerts,
					status: .adding(type)
				)
			case .didRequestDismiss(let type):
				return State(
					alerts: state.alerts,
					status: .deleting(type)
				)
			}
		case .adding:
			switch event {
			case .didAdd(let types):
				return State(
					alerts: types,
					status: .showing
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
			}
		case .deleting:
			switch event {
			case .didDismiss(let types):
				return State(
					alerts: types,
					status: .showing
				)
			default:
				print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
				return state
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
	
	static func whenEditing() -> Feedback<State, Event> {
		Feedback { (state: State) -> AnyPublisher<Event, Never> in
			switch state.status {
			case .adding(let alert):
				let result = {
					var tmp = state.alerts
					tmp.insert(alert)
					return tmp
				}()
				return Just(Event.didAdd(result)).eraseToAnyPublisher()
			case .deleting(let alert):
				let result = {
					var tmp = state.alerts
					tmp.remove(alert)
					return tmp
				}()
				return Just(Event.didDismiss(result)).eraseToAnyPublisher()
			default:
				return Empty().eraseToAnyPublisher()
			}
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
}

