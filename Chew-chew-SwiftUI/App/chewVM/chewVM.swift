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
	let alertViewModel : AlertViewModel
	let searchStopsViewModel : SearchStopsViewModel
	let journeyFollowViewModel : JourneyFollowViewModel
	let recentSearchesViewModel : RecentSearchesViewModel
	let referenceDate : ChewDate
	@Published private(set) var state : State {
		didSet { print("📱 >  state:",state.status.description) }
	}
	private var bag = Set<AnyCancellable>()
	private let input = PassthroughSubject<Event,Never>()
	
	init(initialState : State = State(
		depStop: .textOnly(""),
		   arrStop: .textOnly(""),
		   settings: ChewSettings(),
		   date: .now,
		   status: .start
	   ),
		 referenceDate : ChewDate = .now
	) {
		let coreDataStore = CoreDataStore()
		self.state = initialState
		self.alertViewModel = AlertViewModel()
		self.locationDataManager = LocationDataManager()
		self.searchStopsViewModel = SearchStopsViewModel()
		self.coreDataStore = coreDataStore
		self.journeyFollowViewModel = JourneyFollowViewModel(coreDataStore: coreDataStore,journeys: [])
		self.recentSearchesViewModel = RecentSearchesViewModel(coreDataStore: coreDataStore,searches: [])
		self.referenceDate = referenceDate
		   
	   Publishers.system(
		   initial: state,
		   reduce: Self.reduce,
		   scheduler: RunLoop.main,
		   feedbacks: [
			   Self.userInput(input: input.eraseToAnyPublisher()),
			   self.whenIdleCheckForSufficientDataForJourneyRequest(),
			   self.whenLoadingUserLocation(),
			   self.whenLoadingInitialData(),
			   self.whenEditingStops()
		   ],
		   name: "ChewVM"
	   )
	   .assign(to: \.state, on: self)
	   .store(in: &bag)
	}
	
	init (
		locationDataManager : LocationDataManager,
		searchStopsViewModel : SearchStopsViewModel,
		journeyFollowViewModel : JourneyFollowViewModel,
		recentSearchesViewModel : RecentSearchesViewModel,
		coreDataStore : CoreDataStore,
		alertViewModel : AlertViewModel,
		initialState : State = State(),
		referenceDate : ChewDate = .now
	) {
		self.state = initialState
		self.alertViewModel = alertViewModel
		self.coreDataStore = coreDataStore
		self.locationDataManager = locationDataManager
		self.searchStopsViewModel = searchStopsViewModel
		self.journeyFollowViewModel = journeyFollowViewModel
		self.recentSearchesViewModel = recentSearchesViewModel
		self.referenceDate = referenceDate
		
		Publishers.system(
			initial: state,
			reduce: Self.reduce,
			scheduler: RunLoop.main,
			feedbacks: [
				Self.userInput(input: input.eraseToAnyPublisher()),
				self.whenIdleCheckForSufficientDataForJourneyRequest(),
				self.whenLoadingUserLocation(),
				self.whenLoadingInitialData(),
				self.whenEditingStops()
			],
			name: "ChewVM"
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

extension ChewViewModel {
	
}
