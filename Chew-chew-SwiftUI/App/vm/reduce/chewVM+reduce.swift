//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import Foundation

extension ChewViewModel {
	func transform(_ state: State, _ event: Event){
		if case .didReceiveLocaitonData = event{
			self.topSearchFieldText = "My Location"
		}
	}
	func reduce(_ state: State, _ event: Event) -> State {
		transform(state, event)
		print("⚪🔥 > main event:",event.description,"state:",state.status.description)
		switch state.status {
		case .idle:
			return reduceIdle(state, event)
		case .editingDepartureStop:
			return reduceEditingDepartureStop(state, event)
		case .editingArrivalStop:
			return reduceEditingArrivalStop(state, event)
		case .datePicker:
			return reduceDatePicker(state, event)
		case .journeys:
			return reduceJourneys(state, event)
		case .journeyDetails:
			return reduceJourneyDetails(state, event)
		case .loadingLocation:
			switch event {
			case .onDepartureEdit:
				self.topSearchFieldText = ""
				return State(
					depStop: nil,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					status: .editingDepartureStop,
					searchStopViewModel: SearchLocationViewModel(type: .departure)
				)
			case .onArrivalEdit:
				self.bottomSearchFieldText = ""
				return State(
					depStop: state.depStop,
					arrStop: nil,
					timeChooserDate: state.timeChooserDate,
					status: .editingArrivalStop,
					searchStopViewModel: SearchLocationViewModel(type: .arrival)
				)
			case .onDatePickerDidPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					status: .datePicker
				)
			case .onNewDeparture:
				return state
			case .onNewArrival(let stopType):
				self.bottomSearchFieldText = stopType?.stop.name ?? "no name"
				return State(
					depStop: state.depStop,
					arrStop: stopType,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case .onStopsSwitch:
				return state
			case .onNewDate(let dateType):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: dateType,
					status: .idle
				)
			case .onJourneyDataUpdated:
				return state
			case .onBackFromJourneyDetails:
				return state
			case .didLocationButtonPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case .didReceiveLocaitonData(let lat, let long):
				return State(
					depStop: StopType.location(.init(
						type: "location",
						id: nil,
						name: "My Location",
						address: "My Location",
						location: .init(
							type: "location",
							id: nil,
							latitude: lat,
							longitude: long
						),
						products: nil
					)),
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
			case .didFailToLoadLocationData:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					status: .idle
				)
//			case .didTapJourney:
//				return state
			}
		}
	}
}
