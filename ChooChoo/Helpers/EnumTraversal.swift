//
//  EnumTraversal.swift
//  ChooChoo
//
//  Created by Dmitrii Grigorev on 07.03.24.
//

import Foundation

extension CaseIterable where Self: Equatable {
	func next() -> Self {
		let all = Self.allCases
		let idx = all.firstIndex(of: self)!
		let next = all.index(after: idx)
		return all[next == all.endIndex ? all.startIndex : next]
	}
}
