//
//  JourneyDetails.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 11.09.23.
//

import SwiftUI

struct JourneyDetailsView: View {
	@EnvironmentObject var chewVM : ChewViewModel
	let data : JourneyCollectionViewDataSourse
	var body: some View {
		VStack(alignment: .leading) {
			VStack {
				HStack {
					HStack {
						Text(data.legDTO?.first?.origin?.name ?? "Origin")
							.font(.system(size: 17,weight: .semibold))
							.foregroundColor(.primary)
						Image(systemName: "arrow.right")
						Text(data.legDTO?.last?.destination?.name ?? "Departure")
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
						.font(.system(size: 12,weight: .semibold))
						.background(.ultraThinMaterial.opacity(0.5))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					HStack {
						Text(data.startActualTimeLabelText.isEmpty ? data.startPlannedTimeLabelText : data.startActualTimeLabelText)
						Text("-")
						Text(data.endActualTimeLabelText.isEmpty ? data.endPlannedTimeLabelText : data.endActualTimeLabelText)
					}
						.padding(5)
						.font(.system(size: 12,weight: .semibold))
						.background(.ultraThinMaterial.opacity(0.5))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					Text(data.durationLabelText)
						.padding(5)
						.font(.system(size: 12,weight: .semibold))
						.background(.ultraThinMaterial.opacity(0.5))
						.foregroundColor(.primary.opacity(0.6))
						.cornerRadius(8)
					if data.legDTO?.count ?? 0 > 1 {
						HStack {
							Image(systemName: "arrow.triangle.2.circlepath")
							Text(String((data.legDTO?.count ?? 1) - 1))
						}
							.padding(5)
							.font(.system(size: 12,weight: .semibold))
							.background(.ultraThinMaterial.opacity(0.5))
							.foregroundColor(.primary.opacity(0.6))
							.cornerRadius(8)
					}
					Spacer()
				}
				LegsView(journey : data)
					.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
					.background(.ultraThinMaterial.opacity(0.5))
					.cornerRadius(8)
			}
			
		}
		.padding(10)
		Spacer()
	}
}

