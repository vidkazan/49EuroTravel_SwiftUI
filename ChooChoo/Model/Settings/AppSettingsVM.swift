//
//  AppSettingsVM.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 25.03.24.
//

import Foundation
import Combine


class AppSettingsViewModel : ObservableObject, Identifiable {
	@Published private(set) var state : State {
		didSet { print(">> state:",state.settings) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	
	init(settings : AppSettings = .init()) {
		self.state = State(settings: settings)
		Publishers.system(
			initial: State(settings: settings),
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
			],
			name: ""
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

extension AppSettingsViewModel  {
	struct State : Equatable  {
		let settings : AppSettings

		init(settings: AppSettings = .init()) {
			self.settings = settings
		}
	}
	
	enum Event {
		case didLoadInitialData(settings : AppSettings)
		case didShowTip(tip : AppSettings.ChooTipType)
		case didChangeLegViewMode(mode : AppSettings.LegViewMode)
		var description : String {
			switch self {
			case .didLoadInitialData:
				return "didLoadInitialData"
			case .didShowTip:
				return "didShowTip"
			case .didChangeLegViewMode:
				return "didChangeLegViewMode"
			}
		}
	}
}


extension AppSettingsViewModel {
	static func reduce(_ state: State, _ event: Event) -> State {
		print(">> ",event.description,"state:",state.settings)
		switch event {
		case .didLoadInitialData(let settings):
			return State(settings: settings)
		case .didShowTip(let tip):
			var tips = state.settings.tips
			tips.remove(tip)
			return State(settings: AppSettings(
				oldSettings: state.settings,
				tips: tips
			))
		case .didChangeLegViewMode(let mode):
			return State(settings: AppSettings(
				oldSettings: state.settings,
				legViewMode: mode
			))
		}
	}
}

extension AppSettingsViewModel {
	static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
		Feedback { _ in
			return input
		}
	}
}

