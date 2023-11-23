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
		
		SegmentedPicker(options, selectedItem: $selectedOption, content: { elem in
			Text(getText(elem:elem))
				.frame(maxWidth: .infinity,minHeight: 35)
		},externalAction: optionPressed)
		.padding(5)
		.background(Color.chewGray10)
		.cornerRadius(10)
//		ZStack {
//			// TODO: replace with another custom segmentedControl
//			Rectangle()
//				.fill(Color.chewGray10)
//				.frame(width: UIScreen.main.bounds.width / 2.15 - 25, height: 36)
//				.cornerRadius(8)
//				.padding(4)
//				.offset(x: (selectedOption != 0) ?
//						UIScreen.main.bounds.width / 4.4 - 12.5 :
//							-UIScreen.main.bounds.width / 4.4 + 12.5 )
//				.animation(.spring(response: 0.5), value: selectedOption)
//			HStack(alignment: .top) {
//				ForEach(0..<2) { index in
//					Button(action: {
//						selectedOption = index
//						optionPressed(index)
//					}) {
//						var text : String {
//							switch index {
//							case 0:
//								return "now"
//							case 1:
//								return DateParcer.getTimeAndDateStringFromDate(date: chewVM.state.timeChooserDate.date)
//							default:
//								return ""
//							}
//						}
//						Text(text)
//							.frame(width: UIScreen.main.bounds.width / 2.25 - 25 )
//							.font(.system(size: 15,weight: selectedOption == index ? .semibold : .regular))
//							.foregroundColor(.primary)
//							.cornerRadius(10)
//					}
//				}
//			}
//		}
//		.frame(maxWidth: .infinity,maxHeight: 40)
//		.background(Color.chewGray10)
//		.cornerRadius(10)
//		.transition(.move(edge: .bottom))
//		.animation(.spring(), value: chewVM.state.status)
//		.animation(.spring(), value: chewVM.searchStopsViewModel.state.status)
	}
	
	func getText(elem : TimeSegmentedPickerOptions) -> String {
			switch elem {
			case .now:
				return "now"
			case .specificDate:
				return  DateParcer.getTimeAndDateStringFromDate(date: chewVM.state.timeChooserDate.date)
			}
	}
	
	func optionPressed(selected : TimeSegmentedPickerOptions) {
		switch selected {
		case .now:
			chewVM.send(event: .onNewDate(.now))
		case .specificDate:
			chewVM.send(event: .onDatePickerDidPressed)
		}
	}
}

extension TimeChoosingView {
	
	enum TimeSegmentedPickerOptions : Int {
		case now
		case specificDate
	}
}
