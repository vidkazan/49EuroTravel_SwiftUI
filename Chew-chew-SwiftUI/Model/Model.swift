//
//  Model.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.01.24.
//

import Foundation

import Foundation

final class Model {
	static let shared = Model()
	
	private var _journeyDetailsViewModels : [String: JourneyDetailsViewModel] = [:]
	
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
