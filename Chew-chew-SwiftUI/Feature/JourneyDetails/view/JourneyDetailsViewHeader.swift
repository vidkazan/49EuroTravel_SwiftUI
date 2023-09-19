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
						Text(viewModel.state.data.legDTO?.first?.origin?.name ?? "Origin")
							.font(.system(size: 17,weight: .semibold))
							.foregroundColor(.primary)
						Image(systemName: "arrow.right")
						Text(viewModel.state.data.legDTO?.last?.destination?.name ?? "Departure")
							.font(.system(size: 17,weight: .semibold))
							.foregroundColor(.primary)
					}
					.padding(7)
					.background(.ultraThinMaterial.opacity(0.5))
					.cornerRadius(10)
					Spacer()
				}
				HStack {
					HStack {
						Text(DateParcer.getDateOnlyStringFromDate(date: chewVM.state.timeChooserDate.date))
					}
						.padding(5)
						.font(.system(size: 12,weight: .medium))
						.background(.ultraThinMaterial.opacity(0.5))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					HStack {
						Text(viewModel.state.data.startActualTimeLabelText.isEmpty ? viewModel.state.data.startPlannedTimeLabelText : viewModel.state.data.startActualTimeLabelText)
						Text("-")
						Text(viewModel.state.data.endActualTimeLabelText.isEmpty ? viewModel.state.data.endPlannedTimeLabelText : viewModel.state.data.endActualTimeLabelText)
					}
						.padding(5)
						.font(.system(size: 12,weight: .medium))
						.background(.ultraThinMaterial.opacity(0.5))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					Text(viewModel.state.data.durationLabelText)
						.padding(5)
						.font(.system(size: 12,weight: .medium))
						.background(.ultraThinMaterial.opacity(0.5))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					if viewModel.state.data.legDTO?.count ?? 0 > 1 {
						HStack {
							Image(systemName: "arrow.triangle.2.circlepath")
							Text(String((viewModel.state.data.legDTO?.count ?? 1) - 1))
						}
							.padding(5)
							.font(.system(size: 12,weight: .medium))
							.background(.ultraThinMaterial.opacity(0.5))
							.foregroundColor(.primary.opacity(0.6))
							.cornerRadius(8)
					}
					Spacer()
				}
				LegsView(journey : viewModel.state.data)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
					.background(.ultraThinMaterial.opacity(0.5))
					.cornerRadius(8)
			}
			VStack {
				
			}
				.background(.ultraThinMaterial.opacity(0.5))
		}
	}
}
