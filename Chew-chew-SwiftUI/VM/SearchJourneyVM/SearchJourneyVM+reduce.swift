//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	func transform(_ state: State, _ event: Event){
		print(">>> transform",state.description)
		switch event {
		case .onNewJourneysData(let data):
			self.journeysData = data
			self.constructJourneysCollectionViewData()
		case .onStopsSwitch:
			let tmp = depStop
			depStop = arrStop
			arrStop = tmp
		default:
			break
		}
	}
	func reduce(_ state: State, _ event: Event) -> State {
		transform(state, event)
		print(">> reduce: event:",event,"for",state.description)
		switch state {
		case .idle:
			switch event {
			case .onJourneyDataUpdated:
				return .loadingJourneys
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		case .editingDepartureStop:
			switch event {
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			case .onNewDate, .onStopsSwitch:
				return .idle
			case .onNewDeparture(let stop):
				self.depStop = stop
				return .idle
			default:
				return state
			}
		case .editingArrivalStop:
			switch event {
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onDatePickerDidPressed:
				return .datePicker
			case .onNewDate, .onStopsSwitch:
				return .idle
			case .onNewArrival(let stop):
				self.arrStop = stop
				return .idle
			default:
				return state
			}
		case .datePicker:
			switch event {
			case .onNewDate:
				return .idle
			default:
				return state
			}
		case .loadingJourneys:
			switch event {
			case .onResetJourneyView, .onStopsSwitch, .onNewDate:
				return .idle
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			case .onNewJourneysData:
				return .journeysLoaded
			case .onFailedToLoadJourneysData:
				return .failedToLoadJourneys
			default:
				return state
			}
		case .journeysLoaded:
			switch event {
			case .onResetJourneyView, .onStopsSwitch, .onNewDate:
				return .idle
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			case .onReloadJourneys, .onLaterRef, .onEarlierRef:
				return .loadingJourneys
			case .onJourneyDidPressed:
				return .journeyDetails
			default:
				return state
			}
		case .journeyDetails:
			switch event {
			case .onBackFromJourneyDetails:
				return .journeysLoaded
			default:
				return state
			}
		case .failedToLoadJourneys:
			switch event {
			case .onResetJourneyView, .onStopsSwitch, .onNewDate:
				return .idle
			case .onDepartureEdit:
				return .editingDepartureStop
			case .onArrivalEdit:
				return .editingArrivalStop
			case .onDatePickerDidPressed:
				return .datePicker
			default:
				return state
			}
		}
	}
}
