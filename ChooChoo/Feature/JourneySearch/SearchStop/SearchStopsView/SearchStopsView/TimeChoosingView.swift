//
//  TimeChoosingView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct TimeChoosingView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var searchStopsVM : SearchStopsViewModel
	@State private var selectedOption : TimeSegmentedPickerOptions = .now
	init(
		selectedOption: TimeSegmentedPickerOptions = .now,
		searchStopsVM : SearchStopsViewModel = Model.shared.searchStopsViewModel
	) {
		self.selectedOption = selectedOption
		self.searchStopsVM = searchStopsVM
	}
	var body: some View {
		SegmentedPicker(
			TimeChoosingView.TimeSegmentedPickerOptions.allCases,
			selectedItem: $selectedOption,
			content: { elem in
				Group {
					if #available(iOS 17.0, *) {
						switch elem {
						case .now:
							Text(
								"now",
								 comment: "timeChoosingView: button on segmented picker"
							)
							EmptyView()
						case .specificDate:
							Text(chewVM.state.data.date.date.date, format: .dateTime)
						}
					} else {
						switch elem {
						case .now:
							Text(
								"now",
								comment: "timeChoosingView: button on segmented picker"
							)
						case .specificDate:
							Text(chewVM.state.data.date.date.date, format: .dateTime)
						}
					}
				}
				.frame(maxWidth: .infinity,minHeight: 35)
			},
			externalAction: { (selected : TimeSegmentedPickerOptions)  in
				Task {
					switch selected {
					case .now:
						chewVM.send(event: .didUpdateSearchData(date: SearchStopsDate(
							date: .now,
							mode: .departure
						)))
					case .specificDate:
						Model.shared.sheetViewModel.send(event: .didRequestShow(.date))
					}
				}
			}
		)
		.onReceive(chewVM.$state, perform: { state in
			switch state.data.date.date {
			case .now:
				selectedOption = .now
			case .specificDate:
				selectedOption = .specificDate
			}
		})
		.padding(5)
		.background(Color.chewTimeChoosingViewBG.opacity(0.3))
		.cornerRadius(10)
	}
}

extension TimeChoosingView {
	enum TimeSegmentedPickerOptions : Int, Hashable,CaseIterable {
		case now
		case specificDate
	}
}

#Preview(body: {
	SegmentedPicker(
		["00000","11111"],
		selectedItem: .constant("0"),
		content: {
			Text($0)
		},
		externalAction: {_ in}
	)
	.padding(5)
	.background(Color.chewTimeChoosingViewBG.opacity(0.5))
	.cornerRadius(10)
})
