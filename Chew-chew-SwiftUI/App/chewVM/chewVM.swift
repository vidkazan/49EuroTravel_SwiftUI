//
//  AppVM.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation
import CoreData

final class ChewViewModel : ObservableObject, Identifiable {
	public let coreDataStore : CoreDataStore
	
	@ObservedObject var  locationDataManager : LocationDataManager
	@Published var searchStopsViewModel : SearchStopsViewModel
	@Published var journeyFollowViewModel : JourneyFollowViewModel
	@Published private(set) var state : State {
		didSet { print("⚪ > main new state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	init (
		locationDataManager : LocationDataManager,
		searchStopsViewModel : SearchStopsViewModel,
		journeyFollowViewModel : JourneyFollowViewModel,
		coreDataStore : CoreDataStore
	) {
		self.coreDataStore = coreDataStore
		self.locationDataManager = locationDataManager
		self.searchStopsViewModel = searchStopsViewModel
		self.journeyFollowViewModel = journeyFollowViewModel
		state = State(
			depStop: .textOnly(""),
			arrStop: .textOnly(""),
			settings: ChewSettings(),
			timeChooserDate: .now,
			status: .start
		)
		Publishers.system(
			initial: state,
			reduce: self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenIdleCheckForSufficientDataForJourneyRequest(),
				self.whenLoadingUserLocation(),
				self.whenLoadingInitialData(),
				self.whenEditingStops()
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
