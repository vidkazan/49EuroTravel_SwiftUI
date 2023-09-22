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
							.font(.system(size: 17,weight: .semibold))
							.foregroundColor(.primary)
						Image(systemName: "arrow.right")
						Text(viewModel.state.data.destination)
							.font(.system(size: 17,weight: .semibold))
							.foregroundColor(.primary)
					}
					.padding(7)
//					.background(.ultraThinMaterial.opacity(0.5))
					.background(.gray.opacity(0.1))
					.cornerRadius(10)
					Spacer()
				}
				HStack {
					HStack {
						Text(viewModel.state.data.startDateString)
					}
						.padding(5)
						.font(.system(size: 12,weight: .medium))
//						.background(.ultraThinMaterial.opacity(0.5))
						.background(.gray.opacity(0.1))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					HStack {
						Text(viewModel.state.data.startActualTimeString)
						Text("-")
						Text(viewModel.state.data.endActualTimeString)
					}
						.padding(5)
						.font(.system(size: 12,weight: .medium))
//						.background(.ultraThinMaterial.opacity(0.5))
						.background(.gray.opacity(0.1))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					Text(viewModel.state.data.durationLabelText)
						.padding(5)
						.font(.system(size: 12,weight: .medium))
//						.background(.ultraThinMaterial.opacity(0.5))
						.background(.gray.opacity(0.1))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					if viewModel.state.data.transferCount > 0 {
						HStack {
							Image(systemName: "arrow.triangle.2.circlepath")
							Text(String(viewModel.state.data.transferCount))
						}
							.padding(5)
							.font(.system(size: 12,weight: .medium))
//							.background(.ultraThinMaterial.opacity(0.5))
							.background(.gray.opacity(0.1))
							.foregroundColor(.primary.opacity(0.6))
							.cornerRadius(8)
					}
					Spacer()
				}
				LegsView(journey : viewModel.state.data)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
//					.background(.ultraThinMaterial.opacity(0.5))
					.background(.gray.opacity(0.1))
					.cornerRadius(8)
			}
			
		}
	}
}
