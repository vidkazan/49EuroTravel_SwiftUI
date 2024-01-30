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
		print("🏭 \(#function): vm not found: creating new")
		if let viewData = viewData, let isExpanded = isExpanded {
			let vm = LegDetailsViewModel(leg: viewData,isExpanded: isExpanded)
			legDetailsViewModels[tripId] = vm
			return vm
		}
		let vm = LegDetailsViewModel(leg: .init())
		legDetailsViewModels[tripId] = vm
		return vm
	}
}
