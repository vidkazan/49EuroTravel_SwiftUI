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


class NetworkMonitor {
	private let networkMonitor = NWPathMonitor()
	private let workerQueue = DispatchQueue(label: "Monitor")
	private weak var alertVM : AlertViewModel?

	init(alertVM:  AlertViewModel?) {
		self.alertVM = alertVM
		networkMonitor.pathUpdateHandler = { path in
			switch path.status {
			case .requiresConnection:
				alertVM?.send(event: .didRequestShow)
			case .satisfied:
				alertVM?.send(event: .didTapDismiss)
			case .unsatisfied:
				alertVM?.send(event: .didRequestShow)
			@unknown default:
				fatalError("\(Self.self): unknown networkMonitor status")
			}
		}
		networkMonitor.start(queue: workerQueue)
	}
}
