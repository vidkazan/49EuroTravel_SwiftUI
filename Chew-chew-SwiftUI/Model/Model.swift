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
	
	private var jdvm : [String: JourneyDetailsViewModel] = [:]
	
	func journeyDetailViewModel(
		for journeyRef: String,
		viewdata : JourneyViewData,
		stops : DepartureArrivalPair,
		chewVM : ChewViewModel?
	) -> JourneyDetailsViewModel {
		if let vm = jdvm[journeyRef] {
			return vm
		}
		print("🏭 \(#function): vm not found: creating new")
		let vm = JourneyDetailsViewModel(
			refreshToken: journeyRef,
			data: viewdata,
			depStop: stops.departure,
			arrStop: stops.arrival,
			chewVM: chewVM
		)
		jdvm[journeyRef] = vm
		return vm
	}
}
