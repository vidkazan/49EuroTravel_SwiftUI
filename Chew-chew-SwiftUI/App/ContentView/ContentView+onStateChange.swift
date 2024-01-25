//
//  ContentView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

extension FeatureView {
	func onStateChange() {
		switch chewViewModel.state.status {
		case .sheet:
			bottomSheetIsPresented = true
		default:
			bottomSheetIsPresented = false
		}
	}
}