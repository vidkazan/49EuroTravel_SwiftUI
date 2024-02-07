//
//  SheetView.swift
//  Chew-chew-SwiftUI
//
//  Created by Dmitrii Grigorev on 07.02.24.
//

import Foundation
import SwiftUI

protocol ChewSheetView {
	var closeSheet : ()->Void { get }
}

#warning("make error view")

struct SheetView : View, ChewSheetView {
	@EnvironmentObject var chewViewModel : ChewViewModel
	@ObservedObject var sheetVM : SheetViewModel
	let closeSheet : ()->Void
	var body: some View {
		switch sheetVM.state.status {
		case .error(let error):
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
					FullLegSheetNew(leg: data.leg,closeSheet: closeSheet)
				}
			case .map:
				if let data = data as? MapDetailsViewDataSource {
					MapSheetNew(
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
