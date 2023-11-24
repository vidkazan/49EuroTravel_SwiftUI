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
	private var datePickerIsShowing = false
	private let options : [TimeSegmentedPickerOptions] = [.now,.specificDate]
	init(
		searchStopsVM: SearchStopsViewModel,
		selectedOption: TimeSegmentedPickerOptions = .now,
		datePickerIsShowing: Bool = false
	) {
		self.searchStopsVM = searchStopsVM
		self.selectedOption = selectedOption
		self.datePickerIsShowing = datePickerIsShowing
	}
	var body: some View {
		
		SegmentedPicker(
			options,
			selectedItem: $selectedOption,
			content: { elem in
				Text(getText(elem:elem))
					.frame(maxWidth: .infinity,minHeight: 35)
			},
			externalAction: { (selected : TimeSegmentedPickerOptions)  in
				switch selected {
				case .now:
					chewVM.send(event: .onNewDate(.now))
				case .specificDate:
					chewVM.send(event: .onDatePickerDidPressed)
				}
			}
		)
		.padding(5)
		.background(Color.chewGray10)
		.cornerRadius(10)
	}
	
	func getText(elem : TimeSegmentedPickerOptions) -> String {
			switch elem {
			case .now:
				return "now"
			case .specificDate:
				return  DateParcer.getTimeAndDateStringFromDate(
					date: chewVM.state.timeChooserDate.date
				)
			}
	}
}

extension TimeChoosingView {
	
	enum TimeSegmentedPickerOptions : Int {
		case now
		case specificDate
	}
}
