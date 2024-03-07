//
//  TimeChoosingView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct TimeChoosingView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var searchStopsVM : SearchStopsViewModel = Model.shared.searchStopsViewModel
	@State private var selectedOption : TimeSegmentedPickerOptions = .now
	init(
		selectedOption: TimeSegmentedPickerOptions = .now
	) {
		self.selectedOption = selectedOption
	}
	var body: some View {
		SegmentedPicker(
			TimeChoosingView.TimeSegmentedPickerOptions.allCases,
			selectedItem: $selectedOption,
			content: { elem in
				Text(getText(elem:elem))
					.frame(maxWidth: .infinity,minHeight: 35)
			},
			externalAction: { (selected : TimeSegmentedPickerOptions)  in
				switch selected {
				case .now:
					chewVM.send(event: .onNewDate(SearchStopsDate(
						date: .now,
						mode: .departure
					)))
				case .specificDate:
					Model.shared.sheetViewModel.send(event: .didRequestShow(.date))
				}
			}
		)
		.onReceive(chewVM.$state, perform: { state in
			switch state.date.date {
			case .now:
				selectedOption = .now
			case .specificDate(let ts):
				selectedOption = .specificDate
			}
		})
		.padding(5)
		.background(Color.chewFillSecondary.opacity(0.5))
		.cornerRadius(10)
	}
	
	func getText(elem : TimeSegmentedPickerOptions) -> String {
			switch elem {
			case .now:
				return "now"
			case .specificDate:
				return  DateParcer.getTimeAndDateStringFromDate(
					date: chewVM.state.date.date.date
				)
			}
	}
}

extension TimeChoosingView {
	enum TimeSegmentedPickerOptions : Int, Hashable,CaseIterable {
		case now
		case specificDate
	}
}
