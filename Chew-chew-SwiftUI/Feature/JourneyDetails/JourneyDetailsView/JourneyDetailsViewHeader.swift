//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

extension JourneyDetailsView {
	func header() -> some View {
		VStack(alignment: .leading) {
			VStack {
				HStack {
					HStack {
						Text(viewModel.state.data.origin)
							.chewTextSize(.big)
						Image(systemName: "arrow.right")
						Text(viewModel.state.data.destination)
							.chewTextSize(.big)
					}
					.cornerRadius(10)
					Spacer()
				}
				HStack {
					HStack {
						Text(viewModel.state.data.timeContainer.stringDateValue.departure.actual ?? "")
					}
					.padding(5)
					.chewTextSize(.medium)
					.background(Color.chewFillAccent)
					.cornerRadius(8)
					HStack {
						Text(viewModel.state.data.timeContainer.stringTimeValue.departure.actual ?? "time")
						Text("-")
						Text(viewModel.state.data.timeContainer.stringTimeValue.arrival.actual ?? "time")
					}
					.padding(5)
					.chewTextSize(.medium)
					.background(Color.chewFillAccent)
					.cornerRadius(8)
					Text(viewModel.state.data.durationLabelText)
						.padding(5)
						.chewTextSize(.medium)
						.background(Color.chewFillAccent)
						.cornerRadius(8)
					if viewModel.state.data.transferCount > 0 {
						HStack(spacing: 2) {
							Image(systemName: "arrow.triangle.2.circlepath")
							Text(String(viewModel.state.data.transferCount))
						}
						.padding(5)
						.chewTextSize(.medium)
						.background(Color.chewFillAccent)
						.cornerRadius(8)
					}
					Spacer()
				}
				LegsView(journey : viewModel.state.data)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
			}
			
		}
	}
}
