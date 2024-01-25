//
//  ChewVM+reduce+Idle.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.09.23.
//

import Foundation

extension ChewViewModel {
	func reduceJourneyDetails(_ state:  State, _ event: Event) -> State {
		guard case .journeyDetails = state.status else { return state }
		switch event {
		case .didLoadInitialData,
		 .onDepartureEdit,
		 .onArrivalEdit,
		 .didTapDatePicker,
		 .onNewStop,
		 .onStopsSwitch,
		 .onNewDate(_),
		 .onJourneyDataUpdated,
		 .didLocationButtonPressed,
		 .didReceiveLocationData,
		 .didFailToLoadLocationData,
		 .didSetBothLocations(_, _),
		 .didDismissBottomSheet,
		 .didTapCloseJourneyList,
		 .didStartViewAppear,
		 .onNotEnoughSearchData,
		 .didUpdateSettings:
			print("⚠️ \(Self.self): reduce error: \(state.status) \(event.description)")
			return state
		case .didTapSettings:
			return State(
				depStop: state.depStop,
				arrStop: state.arrStop,
				settings: state.settings,
				timeChooserDate: state.timeChooserDate,
				status: .settings
			)
		}
	}
}
