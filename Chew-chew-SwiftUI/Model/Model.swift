//
//  Model.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.01.24.
//

import Foundation

import Foundation

final class Model {
	static let shared = Model(referenceDate: .now)
	static let preview = Model(referenceDate: .now)
	
	private var _journeyDetailsViewModels : [String: JourneyDetailsViewModel] = [:]
	let referenceDate : ChewDate
	let locationDataManager = LocationDataManager()
	let sheetViewModel : SheetViewModel
	let topBarAlertViewModel : TopBarAlertViewModel
	let coreDataStore = CoreDataStore()
	let searchStopsViewModel : SearchStopsViewModel
	let journeyFollowViewModel : JourneyFollowViewModel
	let recentSearchesViewModel : RecentSearchesViewModel
	let alertViewModel = AlertViewModel()
	
	
	init(
		sheetVM : SheetViewModel = .init(),
		alertVM : TopBarAlertViewModel = .init(),
		searchStopsVM : SearchStopsViewModel = .init(),
		journeyFollowViewModel : JourneyFollowViewModel = .init(journeys: []),
		recentSearchesViewModel : RecentSearchesViewModel = .init(searches: []),
		referenceDate : ChewDate
	) {
		self.searchStopsViewModel = searchStopsVM
		self.topBarAlertViewModel = alertVM
		self.sheetViewModel = sheetVM
		self.journeyFollowViewModel = journeyFollowViewModel
		self.recentSearchesViewModel = recentSearchesViewModel
		self.referenceDate = referenceDate
	}
	
}

extension Model {
	
	func allJourneyDetailViewModels() -> [JourneyDetailsViewModel]{
		return _journeyDetailsViewModels.map({$0.1})
	}
	
	func journeyDetailViewModel(
		followId: Int64,
		for journeyRef: String,
		viewdata : JourneyViewData,
		stops : DepartureArrivalPair,
		chewVM : ChewViewModel?
	) -> JourneyDetailsViewModel {
		if let vm = _journeyDetailsViewModels[journeyRef] {
			return vm
		}
		print("🏭 \(#function): vm not found: creating new")
		let vm = JourneyDetailsViewModel(
			followId: followId,
			data: viewdata,
			depStop: stops.departure,
			arrStop: stops.arrival,
			chewVM: chewVM
		)
		_journeyDetailsViewModels[journeyRef] = vm
		return vm
	}
}
