//
//  TimeChoosingView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI


// TODO: reimplement segmentedControl width making
struct TimeChoosingView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var searchStopsVM : SearchStopsViewModel
	@State private var selectedOption = 0
	private var datePickerIsShowing = false
	private var options = ["now","date"]
	
	init(searchStopsVM: SearchStopsViewModel, selectedOption: Int = 0, datePickerIsShowing: Bool = false, options: [String] = ["now","date"]) {
		self.searchStopsVM = searchStopsVM
		self.selectedOption = selectedOption
		self.datePickerIsShowing = datePickerIsShowing
		self.options = options
	}
	var body: some View {
		ZStack {
			Rectangle()
				.fill(Color.chewGray10)
				.frame(width: UIScreen.main.bounds.width / 2.15 - 25, height: 36)
				.cornerRadius(8)
				.padding(4)
				.offset(x: (selectedOption != 0) ?
						UIScreen.main.bounds.width / 4.4 - 12.5 :
							-UIScreen.main.bounds.width / 4.4 + 12.5 )
				.animation(.spring(response: 0.5), value: selectedOption)
			HStack(alignment: .top) {
				ForEach(0..<2) { index in
					Button(action: {
						selectedOption = index
						optionPressed(index)
					}) {
						var text : String {
							switch index {
							case 0:
								return "now"
							case 1:
								return DateParcer.getTimeAndDateStringFromDate(date: chewVM.state.timeChooserDate.date)
							default:
								return ""
							}
						}
						Text(text)
							.frame(width: UIScreen.main.bounds.width / 2.25 - 25 )
							.font(.system(size: 15,weight: selectedOption == index ? .semibold : .regular))
							.foregroundColor(.primary)
							.cornerRadius(10)
					}
				}
			}
		}
		.frame(maxWidth: .infinity,maxHeight: 43)
		.background(Color.chewGray10)
		.cornerRadius(10)
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: chewVM.state.status)
		.animation(.spring(), value: chewVM.searchStopsViewModel.state.status)
	}
	
	func optionPressed(_ index: Int) {
		switch selectedOption {
		case 0:
			chewVM.send(event: .onNewDate(.now))
		case 1:
			chewVM.send(event: .onDatePickerDidPressed)
		default:
			break
		}
	}
}
