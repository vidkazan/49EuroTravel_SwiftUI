//
//  SheetView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.02.24.
//

import Foundation
import SwiftUI

struct SheetView : View {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var sheetVM : SheetViewModel = Model.shared.sheetViewModel
	let closeSheet : ()->Void
	var body: some View {
		switch sheetVM.state.status {
		case .error(let error):
			#warning("make error view")
			Text(error.localizedDescription)
		case .loading:
			ProgressView()
		case let .showing(type, data):
			switch type {
			case .settings:
				SettingsView(
					settings: chewViewModel.state.settings,
					closeSheet: closeSheet
				)
			case .date:
				if #available(iOS 16.0, *) {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						closeSheet: closeSheet
					)
					.presentationDetents([.height(300),.large])
				} else {
					DatePickerView(
						date: chewViewModel.state.date.date,
						time: chewViewModel.state.date.date,
						closeSheet: closeSheet
					)
				}
			case .fullLeg:
				if let data = data as? FullLegViewDataSource {
					FullLegSheet(leg: data.leg,closeSheet: closeSheet)
				}
			case .map:
				if let data = data as? MapDetailsViewDataSource {
					MapSheet(
						mapRect: data.coordRegion,
						stops: data.stops,
						route: data.route,
						closeSheet: closeSheet
					)
				}
			case .none:
				Text("haha")
			case .onboarding:
				Text("onboarding")
			case .remark:
				Text("remark")
			}
		}
	}
}

@available(iOS 16.0, *)
struct SheetPreviews: PreviewProvider {
	static var previews: some View {
		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.trip,
		   let viewData = mock.legViewData(firstTS: .now, lastTS: .now, legs: [mock]) {
			let sheets : [SheetViewModel.SheetType] = [
				.date,
				.onboarding,
				.remark,
				.settings,
				.fullLeg(leg: viewData),
				.map(leg: viewData)
			]
			ScrollView(.horizontal) {
				HStack {
					ForEach(sheets,id:\.description) { sheet in
						SheetView(
							sheetVM: .init(.loading(sheet)),
							closeSheet: {}
						)
						.frame(maxWidth: 350,maxHeight: 1000)
						.environmentObject(ChewViewModel())
						.border(.black)
					}
				}
			}
//			.previewDevice(.init(iPhoneModel.iPadMini6gen))
//			.previewInterfaceOrientation(.landscapeLeft)
		}
	}
}
