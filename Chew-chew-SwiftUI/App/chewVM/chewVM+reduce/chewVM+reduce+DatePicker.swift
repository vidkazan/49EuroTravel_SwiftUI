//
//  SearchJourneyVM+reduce+2.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation


extension ChewViewModel {
	func reduceDatePicker(_ state:  State, _ event: Event) -> State {
		guard case .datePicker = state.status else { return state }
		switch event {
		case .onNewDate(let date):
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: date,
				status: .idle
			)
		case .didDismissBottomSheet:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .idle
			)
		default:
			return state
		}
	}
}

