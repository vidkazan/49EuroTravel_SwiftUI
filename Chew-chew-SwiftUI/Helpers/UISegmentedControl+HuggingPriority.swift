//
//  UISegmentedControl+HuggingPriority.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 26.10.23.
//

import Foundation
import UIKit

extension UISegmentedControl {
	override open func didMoveToSuperview() {
		super.didMoveToSuperview()
		self.setContentHuggingPriority(.defaultLow, for: .vertical)
	}
}
