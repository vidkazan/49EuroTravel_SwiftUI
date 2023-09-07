//
//  FillableButton.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 29.08.23.
//

import SwiftUI

struct FillableButton: View{
	let text : String
	let isFillable : Bool
	init(text: String,isNotFillable : Bool = true) {
		self.text = text
		self.isFillable = !isNotFillable
	}
	var body: some View {
		ZStack(alignment: .leading){
			Rectangle()
				.fill(.ultraThinMaterial)
				.cornerRadius(10)
				.frame(width: 80,alignment: .leading)
//			if isFillable{
//				Rectangle()
//					.fill(Color(hue: 0.3, saturation: 1, brightness: 0.4))
//					.cornerRadius(10)
//					.frame(width: -viewModel.scrollOffset < 0 ? 0 : -viewModel.scrollOffset*8/15,alignment: .leading)
//					.animation(.easeInOut, value: -viewModel.scrollOffset)
//			}
			Text(text)
				.frame(maxWidth: 80)
				.font(.system(size: 17, weight: .medium))
				.foregroundColor(Color.night)
				.padding(5)
		}
	}
}

