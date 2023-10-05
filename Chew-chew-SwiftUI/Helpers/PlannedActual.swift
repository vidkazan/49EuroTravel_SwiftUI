//
//  PlannedActual.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 05.10.23.
//

import Foundation

struct PrognoseType<T : Equatable > : Equatable {
	let actual : T
	let planned : T
}
