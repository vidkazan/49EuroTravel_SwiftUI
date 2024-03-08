//
//  Set+Toogle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.10.23.
//

import Foundation

extension Set {
	mutating func toogle(val : Element) {
		if self.contains(val) {
			self.remove(val)
		} else {
			self.insert(val)
		}
	}
}
