//
//  SearchJourneyVM+reduce.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 06.09.23.
//

import Foundation

extension SearchJourneyViewModel {
	func reduce(_ state: State, _ event: Event) -> State {
		print(">> event:",event.description,"for",state.status.description)
		switch state.status {
			case .idle:
					switch event {
					case .onJourneyDataUpdated:
						return State(
							depStop: state.depStop,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .loadingJourneys
						)
					case .onDepartureEdit:
						return State(
							depStop: nil,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .editingDepartureStop,
							searchStopViewModel: SearchLocationViewModel(type: .departure)
						)
					case .onArrivalEdit:
						return State(
							depStop: state.depStop,
							arrStop: nil,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .editingArrivalStop,
							searchStopViewModel: SearchLocationViewModel(type: .arrival)
						)
					case .onDatePickerDidPressed:
						return State(
							depStop: state.depStop,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: [],
							status: .datePicker
						)
					default:
						return state
					}
		case .editingDepartureStop:
					switch event {
					case .onArrivalEdit:
						return State(
							depStop: state.depStop,
							arrStop: nil,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .editingArrivalStop,
							searchStopViewModel: SearchLocationViewModel(type: .arrival)
						)
					case .onDatePickerDidPressed:
						return State(
							depStop: state.depStop,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: [],
							status: .datePicker
						)
					case .onNewDate(let date):
						return State(
							depStop: state.depStop,
							arrStop: state.arrStop,
							timeChooserDate: date,
							journeys: state.journeys,
							status: .idle
						)
					case .onStopsSwitch:
						return State(
							depStop: state.arrStop,
							arrStop: state.depStop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .idle
						)
					case .onNewDeparture(let stop):
						self.topSearchFieldText = stop?.name ?? "no name"
						return State(
							depStop: stop,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .idle
						)
					default:
						return state
					}
		case .editingArrivalStop:
					switch event {
					case .onDepartureEdit:
						return State(
							depStop: nil,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .editingDepartureStop,
							searchStopViewModel: SearchLocationViewModel(type: .departure)
						)
					case .onDatePickerDidPressed:
						return State(
							depStop: state.depStop,
							arrStop: state.arrStop,
							timeChooserDate: state.timeChooserDate,
							journeys: [],
							status: .datePicker
						)
					case .onNewDate(let date):
						return State(
							depStop: state.depStop,
							arrStop: state.arrStop,
							timeChooserDate: date,
							journeys: state.journeys,
							status: .idle
						)
					case .onStopsSwitch:
						return State(
							depStop: state.arrStop,
							arrStop: state.depStop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .idle
						)
					case .onNewArrival(let stop):
						self.bottomSearchFieldText = stop?.name ?? "no name"
						return State(
							depStop: state.depStop,
							arrStop: stop,
							timeChooserDate: state.timeChooserDate,
							journeys: state.journeys,
							status: .idle
						)
					default:
						return state
					}
		case .datePicker:
				switch event {
				case .onNewDate(let date):
					return State(
						depStop: state.depStop,
						arrStop: state.arrStop,
						timeChooserDate: date,
						journeys: state.journeys,
						status: .idle
					)
				default:
					return state
				}
		case .loadingJourneys:
			switch event {
			case .onStopsSwitch:
				return State(
					depStop: state.arrStop,
					arrStop: state.depStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .idle
				)
			case .onResetJourneyView:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [],
					status: .idle
				)
			case .onNewDate(let date):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: date,
					journeys: state.journeys,
					status: .idle
				)
			case .onDepartureEdit:
				return State(
					depStop: nil,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .editingDepartureStop,
					searchStopViewModel: SearchLocationViewModel(type: .departure)
				)
			case .onArrivalEdit:
				return State(
					depStop: state.depStop,
					arrStop: nil,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .editingArrivalStop,
					searchStopViewModel: SearchLocationViewModel(type: .arrival)
				)
			case .onDatePickerDidPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [],
					status: .datePicker
				)
			case .onNewJourneysData(let data):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: self.constructJourneysCollectionViewData(journeysData: data),
					status: .journeysLoaded
				)
			case .onFailedToLoadJourneysData:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [.init(id: 0, startTimeLabelText: "-", endTimeLabelText: "-", startDate: .now, endDate: .now, durationLabelText: "error", legs: [], sunEvents: [])],
					status: .failedToLoadJourneys
				)
			default:
				return state
			}
		case .journeysLoaded:
			switch event {
			case .onNewDate(let date):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: date,
					journeys: state.journeys,
					status: .idle
				)
			case .onStopsSwitch:
				return State(
					depStop: state.arrStop,
					arrStop: state.depStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .idle
				)
			case .onResetJourneyView:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [],
					status: .idle
				)
			case .onDepartureEdit:
				return State(
					depStop: nil,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .editingDepartureStop
				)
			case .onArrivalEdit:
				return State(
					depStop: state.depStop,
					arrStop: nil,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .editingArrivalStop
				)
			case .onDatePickerDidPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [],
					status: .datePicker
				)
			case .onReloadJourneys, .onLaterRef, .onEarlierRef:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .loadingJourneys
				)
			case .onJourneyDidPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [.init(id: 0, startTimeLabelText: "-", endTimeLabelText: "-", startDate: .now, endDate: .now, durationLabelText: "journey details", legs: [], sunEvents: [])],
					status: .journeyDetails
				)
			default:
				return state
			}
		case .journeyDetails:
			switch event {
			case .onBackFromJourneyDetails:
				return State(
					depStop: state.arrStop,
					arrStop: state.depStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .idle
				)
			default:
				return state
			}
		case .failedToLoadJourneys:
			switch event {
			case .onStopsSwitch:
				return State(
					depStop: state.arrStop,
					arrStop: state.depStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .idle
				)
			case .onResetJourneyView:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [],
					status: .idle
				)
			case .onNewDate(let date):
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: date,
					journeys: state.journeys,
					status: .idle
				)
			case .onDepartureEdit:
				return State(
					depStop: nil,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .editingDepartureStop,
					searchStopViewModel: SearchLocationViewModel(type: .departure)
				)
			case .onArrivalEdit:
				return State(
					depStop: state.depStop,
					arrStop: nil,
					timeChooserDate: state.timeChooserDate,
					journeys: state.journeys,
					status: .editingArrivalStop,
					searchStopViewModel: SearchLocationViewModel(type: .departure)
				)
			case .onDatePickerDidPressed:
				return State(
					depStop: state.depStop,
					arrStop: state.arrStop,
					timeChooserDate: state.timeChooserDate,
					journeys: [],
					status: .datePicker
				)
			default:
				return state
			}
		}
	}
}
