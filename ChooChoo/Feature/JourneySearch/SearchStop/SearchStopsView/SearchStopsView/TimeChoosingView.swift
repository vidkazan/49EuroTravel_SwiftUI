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
				let text = elem.text(chewVM: chewVM)
				Group {
					if #available(iOS 17.0, *), text == "now" {
						Text(text)
							.popoverTip(ChooTips.searchNowButtonTip, arrowEdge: .bottom)
					} else {
						Text(text)
					}
				}
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
			case .specificDate:
				selectedOption = .specificDate
			}
		})
		.padding(5)
		.background(Color.chewFillSecondary.opacity(0.5))
		.cornerRadius(10)
	}
}

extension TimeChoosingView {
	enum TimeSegmentedPickerOptions : Int, Hashable,CaseIterable {
		case now
		case specificDate
		
		
		func text(chewVM : ChewViewModel) -> String {
			switch self {
			case .now:
				return "now"
			case .specificDate:
				return  DateParcer.getTimeAndDateStringFromDate(
					date: chewVM.state.date.date.date
				)
			}
		}
	}
}
