//
//  JourneyDetailsViewModel.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//


import Foundation
import Combine
import CoreData

final class JourneyDetailsViewModel : ObservableObject, Identifiable, Equatable {
	static func == (lhs: JourneyDetailsViewModel, rhs: JourneyDetailsViewModel) -> Bool {
		lhs.state == rhs.state && lhs.refreshToken == rhs.refreshToken 
	}
	var chewVM : ChewViewModel?
	@Published private(set) var state : State {
		didSet { print("🚂 > state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	var refreshToken : String?
	var depStop : Stop
	var arrStop : Stop
	init (
		refreshToken : String?,
		data: JourneyViewData,
		depStop : Stop,
		arrStop : Stop,
		followList: [String],
		chewVM : ChewViewModel?
	) {
		self.chewVM = chewVM
		self.refreshToken = refreshToken
		self.depStop = depStop
		self.arrStop = arrStop
		state = State(data: data, status: .loadedJourneyData,followList: followList)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenLoadingJourneyByRefreshToken(),
				self.whenLoadingFullLeg(),
				self.whenChangingSubscribitionType(),
				Self.whenLoadingIfNeeded(),
				Self.whenLoadingLocationDetails()
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

extension JourneyDetailsViewModel {
	enum Error : ChewError {
		static func == (lhs: Error, rhs: Error) -> Bool {
			return lhs.description == rhs.description
		}
		
		func hash(into hasher: inout Hasher) {
			switch self {
			case .inputValIsNil:
				break
			}
		}
		case inputValIsNil(_ msg: String)
		
		
		var description : String  {
			switch self {
			case .inputValIsNil(let msg):
				return "Input value is nil: \(msg)"
			}
		}
	}

}
