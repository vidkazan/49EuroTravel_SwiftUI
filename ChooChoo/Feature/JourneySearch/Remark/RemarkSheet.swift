//
//  RemarkSheet.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 09.02.24.
//

import Foundation
import SwiftUI

struct RemarkSheet : View {
	let remarks : [RemarkViewData]
	let closeSheet : ()->Void
	var body: some View {
		NavigationView {
				ScrollView {
					ForEach(remarks,id:\.text.hashValue) { remark in
						HStack {
							VStack(alignment: .leading) {
								HStack(alignment: .top) {
									Image(remark.type.symbol)
										.foregroundColor(remark.type.color)
									VStack(alignment: .leading) {
										Text(remark.summary)
											.chewTextSize(.big)
										Text(remark.text)
											.textContentType(.dateTime)
											.chewTextSize(.medium)
									}
								}
							}
							Spacer()
						}
						.padding(5)
						
					}
				}
			.padding(5)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading, content: {
					Button(action: {
						closeSheet()
					}, label: {
						Text("Close")
							.foregroundColor(.chewGray30)
					})
				})
			}
		}
	}
}

@available(iOS 16.0, *)
struct SheetPreviews: PreviewProvider {
	static var previews: some View {
//		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData
		let mock = Mock.trip.RE6NeussMinden.decodedData
//		if let mock = mock?.journey,
		if let mock = mock?.trip,
//		   let viewData = mock.journeyViewData(depStop: .init(), arrStop: .init(), realtimeDataUpdatedAt: 0) {
		   let viewData = mock.legViewData(firstTS: .now, lastTS: .now, legs: [mock]) {
			let sheets : [SheetViewModel.SheetType] = [
//				.date,
//				.onboarding,
				.remark(remarks: viewData.remarks),
//				.settings,
//				.fullLeg(leg: viewData),
//				.map(leg: viewData)
			]
			ScrollView(.horizontal) {
				HStack {
					ForEach(sheets,id:\.description) { sheet in
						SheetView(
							sheetVM: .init(.loading(sheet)),
							closeSheet: {}
						)
						.frame(maxWidth: 350,maxHeight: 1000,alignment: .leading)
						.environmentObject(ChewViewModel())
					}
					.padding()
				}
			}
//			.previewDevice(.init(iPhoneModel.iPadMini6gen))
//			.previewInterfaceOrientation(.landscapeLeft)
		}
	}
}
