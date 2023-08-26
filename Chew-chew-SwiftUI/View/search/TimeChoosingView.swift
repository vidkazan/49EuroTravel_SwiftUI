//
//  TimeChoosingView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 23.08.23.
//

import SwiftUI

struct TimeChoosingView: View {
	@EnvironmentObject var viewModel : SearchLocationViewModel
	@State private var selectedOption = 0
	private var datePickerIsShowing = false
	private var options = ["now","date"]
   
	var body: some View {
		ZStack {
			Rectangle()
				.frame(
					width: UIScreen.main.bounds.width / 2.2,
					height: 36)
				.cornerRadius(8)
				.foregroundColor(Color(UIColor.white))
				.shadow(radius: 0.5,y: 1)
				.padding(4)
				.offset(
					x: (selectedOption != 0) ?
					UIScreen.main.bounds.width / 4.5 :
						-UIScreen.main.bounds.width / 4.5)
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
								return DateParcer.getTimeAndDateStringFromDate(date: viewModel.timeChooserDate)
							default:
								return ""
							}
						}
						Text(text)
							.frame(width: UIScreen.main.bounds.width / 2.3)
							.font(.system(size: 17))
							.foregroundColor(selectedOption == index ? .primary : .black)
							.fontWeight(selectedOption == index ? .medium : .regular)
							.cornerRadius(10)
						
					}
//					.frame(maxWidth: .infinity,minHeight: 43)
				}
			}
		}
		.frame(maxWidth: .infinity,maxHeight: 43)
		.background(.ultraThinMaterial)
		.cornerRadius(10)
		
	}

	func optionPressed(_ index: Int) {
		switch selectedOption {
		case 0:
			viewModel.updateJourneyTimeValue(date: Date.now)
			
		case 1:
			viewModel.isShowingDatePicker = true
		default:
			break
		}
	}
}

//struct TimeChoosingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeChoosingView()
//    }
//}
