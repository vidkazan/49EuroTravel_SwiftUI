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
					FullLegSheet(
						leg: data.leg,
						closeSheet: closeSheet
					)
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
				EmptyView()
			case .onboarding:
				Text("onboarding")
			case .remark:
				if let data = data as? RemarksViewDataSource {
					if #available(iOS 16.0, *) {
						RemarkSheet(remarks: data.remarks, closeSheet: closeSheet)
							.presentationDetents([.height(300),.large])
					} else {
						RemarkSheet(remarks: data.remarks, closeSheet: closeSheet)
					}
				}
			}
		}
	}
}

enum RemarkType : String {
	case status
	case hint
	
	var priority : Int {
		switch self {
		case .status:
			return 0
		case .hint:
			return 1
		}
	}
	
	var symbol : ChewSFSymbols {
		switch self {
		case .status:
			return .boltFill
		case .hint:
			return .infoCircle
		}
	}
	
	var color : Color {
		switch self {
		case .status:
			return .chewFillRedPrimary
		case .hint:
			return .primary.opacity(0.8)
		}
	}
	
}

struct RemarkSheet : View {
	let remarks : [Remark]
	let closeSheet : ()->Void
	var body: some View {
		NavigationView {
			VStack(alignment: .leading) {
				ScrollView {
					ForEach(remarks,id:\.text?.hashValue) { remark in
						HStack {
							VStack(alignment: .leading) {
								let type : RemarkType = RemarkType(rawValue: remark.type ?? "info")!
								HStack(alignment: .top) {
									Image(type.symbol)
										.foregroundColor(type.color)
									VStack(alignment: .leading) {
										Text(remark.summary ?? "")
											.chewTextSize(.big)
										Text(remark.text ?? "text")
											.textContentType(.dateTime)
											.chewTextSize(.medium)
									}
								}
							}
							Spacer()
						}
						
					}
				}
			}
			.padding(10)
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
		let mock = Mock.journeys.journeyNeussWolfsburg.decodedData
//		let mock = Mock.trip.RE6NeussMinden.decodedData
		if let mock = mock?.journey,
//		if let mock = mock?.trip,
		   let viewData = mock.journeyViewData(depStop: .init(), arrStop: .init(), realtimeDataUpdatedAt: 0) {
//		   let viewData = mock.legViewData(firstTS: .now, lastTS: .now, legs: [mock]) {
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
