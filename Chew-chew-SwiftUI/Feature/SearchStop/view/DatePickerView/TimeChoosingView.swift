//
//  TimeChoosingView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct TimeChoosingView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	@ObservedObject var searchStopViewModel : SearchLocationViewModel
	@State private var selectedOption = 0
	private var datePickerIsShowing = false
	private var options = ["now","date"]
   
	init(searchStopViewModel: SearchLocationViewModel) {
		self.searchStopViewModel = searchStopViewModel
	}
	var body: some View {
		ZStack {
			Rectangle()
				.fill(.ultraThickMaterial)
//				.fill(.gray.opacity(0.3))
				.frame(width: UIScreen.main.bounds.width / 2.15, height: 36)
				.cornerRadius(8)
				.padding(4)
				.offset(x: (selectedOption != 0) ?
						UIScreen.main.bounds.width / 4.4 :
							-UIScreen.main.bounds.width / 4.4)
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
							.frame(width: UIScreen.main.bounds.width / 2.25)
							.font(.system(size: 17,weight: selectedOption == index ? .semibold : .regular))
							.foregroundColor(selectedOption == index ? .primary : .primary)
							.cornerRadius(10)
					}
				}
			}
		}
		.frame(maxWidth: .infinity,maxHeight: 43)
		.background(.ultraThinMaterial.opacity(0.7))
//		.background(.gray.opacity(0.10))
		.cornerRadius(10)
		.transition(.move(edge: .bottom))
		.animation(.spring(), value: chewVM.state.status)
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
