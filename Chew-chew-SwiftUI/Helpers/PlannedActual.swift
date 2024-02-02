//
//  PlannedActual.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.10.23.
//

import Foundation

struct Prognosed<T : Equatable> : Equatable {
	var actual : T?
	var planned : T?
	
	func actualOrPlannedIfActualIsNil() -> T? {
		return actual == nil ? planned : actual
	}
}

struct PrognosedDirection<T : Equatable> : Equatable {
	let actual : T
	let planned : T
}
