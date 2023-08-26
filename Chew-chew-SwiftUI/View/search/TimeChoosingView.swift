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
	@State private var datePickerIsShowing = false
	private let options = ["now", "23 aug 2023, 15:03"]
	   
	var body: some View {
		ZStack {
			Rectangle()
				.frame(height: 36)
				.cornerRadius(10)
				.foregroundColor(Color(UIColor.systemGray6))
			Rectangle()
				.frame(
					width: UIScreen.main.bounds.width / 2.2,
					height: 29)
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
				ForEach(0..<options.count, id: \.self) { index in
					Button(action: {
						selectedOption = index
						optionPressed(index)
					}) {
						Text(options[index])
							.frame(width: UIScreen.main.bounds.width / 2.3)
							.font(.system(size: 17))
							.foregroundColor(Color(UIColor.black))
							.fontWeight(selectedOption == index ? .medium : .regular)
							.cornerRadius(10)
					}
					.frame(maxWidth: .infinity)
				}
			}
		}
	}

	func optionPressed(_ index: Int) {
		if selectedOption == 1 {
			viewModel.isShowingDatePicker = true
		}
		print("Option Pressed: \(options[index])")
	}
}

//struct TimeChoosingView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimeChoosingView()
//    }
//}
