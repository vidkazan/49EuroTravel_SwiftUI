//
//  Model.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.01.24.
//

import Foundation

final class Model {
	static let shared = Model()
	
	var legDetailsViewModels : [String : LegDetailsViewModel] = [:]
	var journeyDetailsViewModels : [String : JourneyDetailsViewModel] = [:]
	
	func legDetailsViewModel(tripId : String, isExpanded : Bool?, viewData : LegViewData? = nil) -> LegDetailsViewModel {
		if let vm = legDetailsViewModels[tripId] {
			return vm
		}
		print("🏭 \(#function): not found: creating new")
		if let viewData = viewData, let isExpanded = isExpanded {
			let vm = LegDetailsViewModel(leg: viewData,isExpanded: isExpanded)
			legDetailsViewModels[tripId] = vm
			return vm
		}
		let vm = LegDetailsViewModel()
		legDetailsViewModels[tripId] = vm
		return vm
	}
	
	func journeyDetailsViewModel(
		journeyRef : String,
		viewData : JourneyViewData? = nil,
		stops : DepartureArrivalPair? = nil,
		followList : [String]? = nil,
		chewVM : ChewViewModel? = nil
	) -> JourneyDetailsViewModel {
		print("🏭 \(#function): not found: creating new")
		if let viewData = viewData,
		   let stops = stops,
		   let followList = followList,
		   let chewVM = chewVM {
			let vm = JourneyDetailsViewModel(
				refreshToken: journeyRef,
				data: viewData,
				depStop: stops.departure,
				arrStop: stops.arrival,
				followList: followList,
				chewVM: chewVM
			)
			journeyDetailsViewModels[journeyRef] = vm
			return vm
		}
		let vm = journeyDetailsViewModel(
			journeyRef: journeyRef,
			chewVM: nil
		)
		journeyDetailsViewModels[journeyRef] = vm
		return vm
	}
}
